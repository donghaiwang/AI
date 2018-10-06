package test0820;

import java.io.IOException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.VLongWritable;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.SequenceFileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;


public class SFInput02 {
    public static void main(String[] args) throws Exception {
        Job job = Job.getInstance(new Configuration());
        job.setJarByClass(SFinput.class);

        job.setMapperClass(SFMapper.class);
        job.setReducerClass(SFReducer.class);

        job.setMapOutputKeyClass(Text.class);
        job.setMapOutputValueClass(VLongWritable.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(VLongWritable.class);

        job.setInputFormatClass(SequenceFileInputFormat.class);

        SequenceFileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        job.waitForCompletion(true);
    }
    public static class SFMapper extends Mapper<Text, VLongWritable,Text, VLongWritable> {
        public void map(Text key, VLongWritable value, Context context)
                throws IOException, InterruptedException {
            context.write(key, value);
        }

    }
    //reduce
    public static class SFReducer extends Reducer<Text, VLongWritable,Text, VLongWritable>{
        @Override
        protected void reduce(Text key, Iterable<VLongWritable> v2s,Context context)
                throws IOException, InterruptedException {
            for(VLongWritable vl : v2s){
                context.write(key, vl);
            }
        }
    }
}