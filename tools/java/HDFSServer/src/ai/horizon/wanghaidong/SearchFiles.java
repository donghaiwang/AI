package ai.horizon.wanghaidong;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import org.apache.hadoop.conf.Configured;
import org.apache.hadoop.filecache.DistributedCache;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;
import org.apache.hadoop.util.GenericOptionsParser;
import org.apache.hadoop.util.Tool;


public class SearchFiles extends Configured implements Tool {
	
	public static class MapClass extends Mapper<LongWritable, Text, Text, Text> {

		private Map<String, String> deptMap = new HashMap<String, String>();	// ���ڻ���dept�ļ��е�����
		private String[] kv;

		
		// �˷�������Map����ִ��֮ǰִ��һ�Σ���ִֻ��һ��
		/*
		@Override
		protected void setup(Context context) throws IOException, InterruptedException {
			BufferedReader in = null;
			try {
				// �ӵ�ǰ��ҵ�л�ȡҪ������ļ�
				Path[] paths = DistributedCache.getLocalCacheFiles(context.getConfiguration());
				String deptIdName = null;
				for (Path path : paths) {
					// �Բ������ֽ��в�ֲ����浽depMap��
					if (path.toString().contains("dept")) {
						in = new BufferedReader(new FileReader(path.toString()));
						while (null != (deptIdName = in.readLine())) {
							// ����Map��KeyΪ���ű�ţ�valueΪ���ڲ�������
							deptMap.put(deptIdName.split(",")[0], deptIdName.split(",")[1]);
						}
					}
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (in != null) {
						in.close();
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		*/
		
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
			// ��valueֵ���в��
			// ��Ա���ļ��ֶν��в��
			kv = value.toString().split(",");
			// map join: ��map�׶ι��˵�����Ҫ�����ݣ����keyΪ�������ƣ�valueΪԱ������
			if (deptMap.containsKey(kv[7])) {
				if (null != kv[5] && !"".equals(kv[5].toString())) {
					context.write(new Text(deptMap.get(kv[7].trim())), new Text(kv[5].trim()));		// д�ļ�д������
				}
			}
		}
		
		/*
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
			// ��Ա���ļ��ֶν��в��
			kv = value.toString().split(",");
			// map join: ��map�׶ι��˵�����Ҫ�����ݣ����keyΪ�������ƣ�valueΪԱ������
			if (deptMap.containsKey(kv[7])) {
				if (null != kv[5] && !"".equals(kv[5].toString())) {
					context.write(new Text(deptMap.get(kv[7].trim())), new Text(kv[5].trim()));
				}
			}
		}
		*/
	}

	public static class Reduce extends Reducer<Text, Text, Text, LongWritable> {

		public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {

			long sumSalary = 0;
			for (Text val : values) {
				sumSalary += Long.parseLong(val.toString());
			}

			context.write(key, new LongWritable(sumSalary));
		}
	}
	

	@Override
	public int run(String[] args) throws Exception {
		Job job = new Job(getConf(), "SearchFiles");
		job.setJobName("SearchFiles");
		job.setJarByClass(SearchFiles.class);
		job.setMapperClass(MapClass.class);
		job.setReducerClass(Reduce.class);

		job.setInputFormatClass(TextInputFormat.class);

		job.setOutputFormatClass(TextOutputFormat.class);
		job.setOutputKeyClass(Text.class);		// ���������key, value
		job.setOutputValueClass(Text.class);
		
		System.out.println("hehe");

		String[] otherArgs = new GenericOptionsParser(job.getConfiguration(), args).getRemainingArgs();
		DistributedCache.addCacheFile(new Path(otherArgs[0]).toUri(), job.getConfiguration());	// dept
		FileInputFormat.addInputPath(job, new Path(otherArgs[1]));		// emp
		FileOutputFormat.setOutputPath(job, new Path(otherArgs[2]));

		job.waitForCompletion(true);
		return job.isSuccessful() ? 0 : 1;
	}

}
