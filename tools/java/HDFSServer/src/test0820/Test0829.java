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

		job.setMapperClass(WCMapper.class); // 设置mapper类
		job.setReducerClass(WCReducer.class); // 设置reducer类

		job.setOutputKeyClass(Text.class); // 输出key的类别
		job.setOutputValueClass(VLongWritable.class); // 输出value的类别

		// 设置输出类
		job.setOutputFormatClass(SequenceFileOutputFormat.class);

		/**
		 * 设置sequecnfile的格式，对于sequencefile的输出格式，有多种组合方式, 从下面的模式中选择一种，并将其余的注释掉
		 */

		// 组合方式1：不压缩模式
		// NONE: 对records不进行压缩; (组合1)
		SequenceFileOutputFormat.setOutputCompressionType(job, CompressionType.NONE);

		// 组合方式2：record压缩模式，并指定采用的压缩方式 ：默认、gzip压缩等
		// RECORD: 仅压缩每一个record中的value值(不包括key); (组合2)
		// SequenceFileOutputFormat.setOutputCompressionType(job,
		// CompressionType.RECORD);
		// SequenceFileOutputFormat.setOutputCompressorClass(job,
		// DefaultCodec.class);

		// BLOCK: 将一个block中的所有records(包括key)压缩在一起;(组合3)
		// 组合方式3：block压缩模式，并指定采用的压缩方式 ：默认、gzip压缩等
		// SequenceFileOutputFormat.setOutputCompressionType(job,
		// CompressionType.BLOCK);
		// SequenceFileOutputFormat.setOutputCompressorClass(job,
		// DefaultCodec.class);

		FileInputFormat.addInputPaths(job, args[0]); // 输入文件路径
		SequenceFileOutputFormat.setOutputPath(job, new Path(args[1])); // 输出文件路径（必须不存在）

		job.waitForCompletion(true); // 等待MR任务完成
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
