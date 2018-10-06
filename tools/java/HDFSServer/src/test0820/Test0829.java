package test0820;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.SequenceFile.CompressionType;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.VLongWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.SequenceFileOutputFormat;

public class Test0829 {

	public static void main(String[] args) throws Exception {
		Configuration conf = new Configuration();
		Job job = Job.getInstance(conf);
		job.setJarByClass(Test0829.class);

		job.setMapperClass(WCMapper.class); // ����mapper��
		job.setReducerClass(WCReducer.class); // ����reducer��

		job.setOutputKeyClass(Text.class); // ���key�����
		job.setOutputValueClass(VLongWritable.class); // ���value�����

		// ���������
		job.setOutputFormatClass(SequenceFileOutputFormat.class);

		/**
		 * ����sequecnfile�ĸ�ʽ������sequencefile�������ʽ���ж�����Ϸ�ʽ, �������ģʽ��ѡ��һ�֣����������ע�͵�
		 */

		// ��Ϸ�ʽ1����ѹ��ģʽ
		// NONE: ��records������ѹ��; (���1)
		SequenceFileOutputFormat.setOutputCompressionType(job, CompressionType.NONE);

		// ��Ϸ�ʽ2��recordѹ��ģʽ����ָ�����õ�ѹ����ʽ ��Ĭ�ϡ�gzipѹ����
		// RECORD: ��ѹ��ÿһ��record�е�valueֵ(������key); (���2)
		// SequenceFileOutputFormat.setOutputCompressionType(job,
		// CompressionType.RECORD);
		// SequenceFileOutputFormat.setOutputCompressorClass(job,
		// DefaultCodec.class);

		// BLOCK: ��һ��block�е�����records(����key)ѹ����һ��;(���3)
		// ��Ϸ�ʽ3��blockѹ��ģʽ����ָ�����õ�ѹ����ʽ ��Ĭ�ϡ�gzipѹ����
		// SequenceFileOutputFormat.setOutputCompressionType(job,
		// CompressionType.BLOCK);
		// SequenceFileOutputFormat.setOutputCompressorClass(job,
		// DefaultCodec.class);

		FileInputFormat.addInputPaths(job, args[0]); // �����ļ�·��
		SequenceFileOutputFormat.setOutputPath(job, new Path(args[1])); // ����ļ�·�������벻���ڣ�

		job.waitForCompletion(true); // �ȴ�MR�������
	}

	// map
	public static class WCMapper extends Mapper<LongWritable, Text, Text, VLongWritable> {
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
			String[] split = value.toString().split(":", 2);
			if (split.length != 1) {
				String[] splited = split[1].split(",");
				for (String s : splited) {
					context.write(new Text(s), new VLongWritable(1L));
				}
			}
		}
	}

	// reduce
	public static class WCReducer extends Reducer<Text, VLongWritable, Text, VLongWritable> {
		@Override
		protected void reduce(Text key, Iterable<VLongWritable> v2s, Context context)
				throws IOException, InterruptedException {

			long sum = 0;

			for (VLongWritable vl : v2s) {
				sum += vl.get();
			}
			context.write(key, new VLongWritable(sum));
		}
	}
}
