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

		private Map<String, String> deptMap = new HashMap<String, String>();	// 用于缓存dept文件中的数据
		private String[] kv;

		
		// 此方法会在Map方法执行之前执行一次，且只执行一次
		/*
		@Override
		protected void setup(Context context) throws IOException, InterruptedException {
			BufferedReader in = null;
			try {
				// 从当前作业中获取要缓存的文件
				Path[] paths = DistributedCache.getLocalCacheFiles(context.getConfiguration());
				String deptIdName = null;
				for (Path path : paths) {
					// 对部门文字进行拆分并缓存到depMap中
					if (path.toString().contains("dept")) {
						in = new BufferedReader(new FileReader(path.toString()));
						while (null != (deptIdName = in.readLine())) {
							// 其中Map中Key为部门编号，value为所在部门名称
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
			// 对value值进行拆分
			// 对员工文件字段进行拆分
			kv = value.toString().split(",");
			// map join: 在map阶段过滤掉不需要的数据，输出key为部门名称，value为员工工资
			if (deptMap.containsKey(kv[7])) {
				if (null != kv[5] && !"".equals(kv[5].toString())) {
					context.write(new Text(deptMap.get(kv[7].trim())), new Text(kv[5].trim()));		// 写文件写到本地
				}
			}
		}
		
		/*
		public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
			// 对员工文件字段进行拆分
			kv = value.toString().split(",");
			// map join: 在map阶段过滤掉不需要的数据，输出key为部门名称，value为员工工资
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
		job.setOutputKeyClass(Text.class);		// 设置输出的key, value
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
