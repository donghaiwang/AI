package ai.horizon.wanghaidong;

import java.io.BufferedInputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.RandomAccessFile;
import java.net.URI;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileChannel.MapMode;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.UUID;

import org.apache.commons.collections.set.SynchronizedSet;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.IOUtils;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.MapFile;
import org.apache.hadoop.io.MapFile.Reader;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.MapFileOutputFormat;
import org.apache.hadoop.mapreduce.lib.partition.HashPartitioner;
import org.apache.hadoop.util.ReflectionUtils;

public class HDFSMain {

	/**
	 * @param args
	 */
	public static FileSystem fs;
	public static Configuration conf = new Configuration();
	private static String destPrefix = "hdfs://10.10.10.34:8020";	// hdfs://yz-gpu034.hogpu.cc:8020
	private static String destDirectory = "/user/wanghaidong/AP2/";	// /user/test/
	
	private static String downloadBufferDirectoryPrefix = "/home/haidong.wang/download/";
	private static String httpPrefix = "http://10.10.10.184:8080/download/";
	private static String uploadListFileName = "upload.list";
	private static String downloadListFileName = "download.list";
	private static String deleteListFileName = "delete.list";
	
	
	
	public static int writeToSequenceFile(String srcPath) throws IOException {
		File mFile = new File(srcPath);
		if (mFile.isFile()) {
			String srcFileName = srcPath.trim();
			String sFileName = srcFileName.substring(srcFileName.lastIndexOf("/")+1);
			String destPath = destDirectory + sFileName + ".seq";
			destPath = destPrefix + destPath; 		// 加入计算机名和端口号
			Path path = new Path(destPath);	// 如果上传的是单个文件，seq文件名与原来文件名一样
			FileSystem fs = FileSystem.get(URI.create(destPath), conf);
			SequenceFile.Writer writer = SequenceFile.createWriter(fs, conf, path, Text.class, BytesWritable.class);
			
			File file1 = new File(srcPath);
			byte[] fileByteArray = toByteArray(file1.getAbsolutePath());
			BytesWritable bytesWritable = new BytesWritable(fileByteArray);
			Text key = new Text();
			key.set(file1.getName());
            writer.append(key, bytesWritable);
            writer.close();
            
            System.out.println("0");
            System.out.println(destPath);
            writeContentToFile(uploadListFileName, "0 " + destPath);
		} else if (mFile.isDirectory()) {
			UUID uuid = UUID.randomUUID();
			String destPath = destDirectory + uuid + ".seq";
			destPath = destPrefix + destPath;		// 加入计算机名和端口号
			Path path = new Path(destPath);	// 如果上传的是一个目录，seq文件名使用UUID生成，里面的文件名保持不变
			FileSystem fs = FileSystem.get(URI.create(destPath), conf);
			SequenceFile.Writer writer = SequenceFile.createWriter(fs, conf, path, Text.class, BytesWritable.class);
			Text key = new Text();
			
			if (mFile.exists() && mFile.isDirectory()) {
				List<File> mlist = new ArrayList<File>();
	            getAllFile(mFile, mlist);
	            for (File file2 : mlist) {
	                byte[] fileByteArray = toByteArray(file2.getAbsolutePath());
	                BytesWritable bytesWritable = new BytesWritable(fileByteArray);
	                key.set(file2.getName());
	                writer.append(key, bytesWritable);
	            }
			}
			System.out.println("0");
			System.out.println(destPath);
			writeContentToFile(uploadListFileName, "0 " + destPath);
			writer.close();
		} else {
			System.out.println("1");
			System.out.println("Souce file path is not exit!");
			writeContentToFile(uploadListFileName, "1 " + "Souce file path is not exit!");
			return 1;
		}
		return 0;
	}
	
	
	public static int writeToMapFile(String srcPath) throws IOException {
		File mFile = new File(srcPath);
		if (mFile.isFile()) {
			String srcFileName = srcPath.trim();
			String sFileName = srcFileName.substring(srcFileName.lastIndexOf("/")+1);
			String destPath = destDirectory + sFileName + ".map";
			destPath = destPrefix + destPath; 		// 加入计算机名和端口号
			Path path = new Path(destPath);	// 如果上传的是单个文件，seq文件名与原来文件名一样
//			System.out.println(destPath);
			FileSystem fs = FileSystem.get(URI.create(destPath), conf);
//			SequenceFile.Writer writer = SequenceFile.createWriter(fs, conf, path, Text.class, BytesWritable.class);
			MapFile.Writer writer = new MapFile.Writer(conf, fs, path.toString(), Text.class, BytesWritable.class);
			
			File file1 = new File(srcPath);
			byte[] fileByteArray = toByteArray(file1.getAbsolutePath());
			BytesWritable bytesWritable = new BytesWritable(fileByteArray);
			Text key = new Text();
			key.set(file1.getName());
            writer.append(key, bytesWritable);
            writer.close();
            
            System.out.println("0");
            System.out.println(destPath);
            writeContentToFile(uploadListFileName, "0 " + destPath);
		} else if (mFile.isDirectory()) {
			UUID uuid = UUID.randomUUID();
			String destPath = destDirectory + uuid + ".map";
			destPath = destPrefix + destPath;		// 加入计算机名和端口号
			Path path = new Path(destPath);	// 如果上传的是一个目录，seq文件名使用UUID生成，里面的文件名保持不变
			FileSystem fs = FileSystem.get(URI.create(destPath), conf);
			MapFile.Writer writer = new MapFile.Writer(conf, fs, path.toString(), Text.class, BytesWritable.class);
			Text key = new Text();
			
			if (mFile.exists() && mFile.isDirectory()) {
				List<File> mlist = new ArrayList<File>();
	            getAllFile(mFile, mlist);
	            Collections.sort(mlist, new SortByName());
	            System.out.println(mlist);
	            for (File file2 : mlist) {
	                byte[] fileByteArray = toByteArray(file2.getAbsolutePath());
	                BytesWritable bytesWritable = new BytesWritable(fileByteArray);
	                key.set(file2.getName());
	                writer.append(key, bytesWritable);
	            }
			}
			System.out.println("0");
			System.out.println(destPath);
			writeContentToFile(uploadListFileName, "0 " + destPath);
			writer.close();
		} else {
			System.out.println("1");
			System.out.println("Souce file path is not exit!");
			writeContentToFile(uploadListFileName, "1 " + "Souce file path is not exit!");
			return 1;
		}
		return 0;
	}
	
	
	private static void getAllFile(File mFile, List<File> mlist) {
        // 1.获取子目录
        File[] files = mFile.listFiles();
        // 2.判断files是否是空的 否则程序崩溃
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    getAllFile(file, mlist);//调用递归的方式
                } else {
                    // 4. 添加到集合中去
                    String fileName = file.getName();
                    if (fileName.endsWith(".jpg") || fileName.endsWith(".png")
                            || fileName.endsWith(".gif")) {
                        mlist.add(file);//如果是这几种图片格式就添加进去
                    }
                }
            }
        }
	}
	
	
	/** 
     * Mapped File way MappedByteBuffer 可以在处理大文件时，提升性能 
     *  
     * @param filename 
     * @return 
     * @throws IOException 
     */  
    public static byte[] toByteArray(String filename) throws IOException {  
  
        FileChannel fc = null;  
        try {  
            fc = new RandomAccessFile(filename, "r").getChannel();  
            MappedByteBuffer byteBuffer = fc.map(MapMode.READ_ONLY, 0,  
                    fc.size()).load();  
            System.out.println(byteBuffer.isLoaded()); 
            byte[] result = new byte[(int) fc.size()]; 
            if (byteBuffer.remaining() > 0) {  
                // System.out.println("remain");  
                byteBuffer.get(result, 0, byteBuffer.remaining());  
            }  
            return result;  
        } catch (IOException e) {  
            e.printStackTrace();  
            throw e;  
        } finally {  
            try {  
                fc.close();  
            } catch (IOException e) {  
                e.printStackTrace();  
            }  
        }  
    }  
	

	
	public static int readFromSequenceFile(String remoteSeqFilePath) {
		UUID uuid = UUID.randomUUID();
		String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid.toString() + "/";
		File mFile = new File(downloadBufferDirectory);
		if (!mFile.exists()) {
			if (!mFile.mkdirs()) {
				System.out.println("1");
				System.out.println("Create directory " + mFile.toString() + " failed!");
				writeContentToFile(downloadListFileName, "1 " + "Create directory " + mFile.toString() + " failed!");
				return 1;
			}
		}
		
		try {
			FileSystem fs = FileSystem.get(URI.create(remoteSeqFilePath), conf);
			SequenceFile.Reader reader = new SequenceFile.Reader(fs, new Path(remoteSeqFilePath), conf);
			Text key = new Text();
			int fileLength = (int) fs.getLength(new Path(remoteSeqFilePath));
			BytesWritable bytesWritable = new BytesWritable();
			while (reader.next(key, bytesWritable)) {
//				System.out.println(key);
				String fileName = downloadBufferDirectory + "/" + key.toString();
				FileOutputStream fos = new FileOutputStream(fileName);
				byte[] copyBytes = bytesWritable.copyBytes();
				fos.write(copyBytes);						// Get a copy of the bytes that is exactly the length of the data.
				fos.close();
			}
			System.out.println("0");
			System.out.println(httpPrefix + uuid.toString() + "/");
			writeContentToFile(downloadListFileName, "0 " + httpPrefix + uuid.toString() + "/");
		} catch (IOException e) {
			System.out.println("1");
			System.out.println("HDFS path wrong!");
			writeContentToFile(downloadListFileName, "1 " + "HDFS path wrong!");
		}
		
		
		return 0;
	}
	
	
	public static int readFromMapFile(String remoteSeqFilePath) {
		UUID uuid = UUID.randomUUID();
		String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid.toString() + "/";
		File mFile = new File(downloadBufferDirectory);
		if (!mFile.exists()) {
			if (!mFile.mkdirs()) {
				System.out.println("1");
				System.out.println("Create directory " + mFile.toString() + " failed!");
				writeContentToFile(downloadListFileName, "1 " + "Create directory " + mFile.toString() + " failed!");
				return 1;
			}
		}
		
		try {
			FileSystem fs = FileSystem.get(URI.create(remoteSeqFilePath), conf);
			Path mapFile = new Path(remoteSeqFilePath);
			MapFile.Reader reader=new MapFile.Reader(fs, mapFile.toString(), conf); 
			Text key = new Text();
			BytesWritable bytesWritable = new BytesWritable();
			while (reader.next(key, bytesWritable)) {
				String fileName = downloadBufferDirectory + "/" + key.toString();
				FileOutputStream fos = new FileOutputStream(fileName);
				byte[] copyBytes = bytesWritable.copyBytes();
				fos.write(copyBytes);						// Get a copy of the bytes that is exactly the length of the data.
				fos.close();
			}
			System.out.println("0");
			System.out.println(httpPrefix + uuid.toString() + "/");
			writeContentToFile(downloadListFileName, "0 " + httpPrefix + uuid.toString() + "/");
		} catch (IOException e) {
			System.out.println("1");
			System.out.println("HDFS path wrong!");
			writeContentToFile(downloadListFileName, "1 " + "HDFS path wrong!");
		}
		
		
		return 0;
	}
	
	
	
	public static int deleteFileInHDFS(String remoteFilePath) {
		try {
			FileSystem fs = FileSystem.get(URI.create(remoteFilePath), conf);
			fs.delete(new Path(remoteFilePath), true);
			fs.close();
			System.out.println("0");
			System.out.println("Delete HDFS file success!");
			writeContentToFile(deleteListFileName, "0 " + "Delete HDFS file success!");
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("1");
			System.out.println("HDFS path wrong!");
			return 1;
		}
	}
	
	
	public static class ReadFileMapper extends Mapper<LongWritable, Text, LongWritable, Text> {
//		FileSystem fs = FileSystem.get(URI.create(remoteSeqFilePath), conf);
//        seqReader = new SequenceFile.Reader(fs, path, conf);  // path为SequenceFile文件的路径
		private static Path testPath = new Path("/user/data/test1/data_000001.seq");
		private static SequenceFile.Reader seqReader;
		/*
		 * (non-Javadoc)
		 * 
		 * @see org.apache.hadoop.mapreduce.Mapper#map(KEYIN, VALUEIN,
		 * org.apache.hadoop.mapreduce.Mapper.Context)
		 */
		@Override
		public void map(LongWritable key, Text value, Context context) {
			try {
				seqReader = new SequenceFile.Reader(FileSystem.get(URI.create("/user/data/test1/data_000001.seq"), conf), new Path("/user/data/test1/data_000001.seq"), conf);
				System.out.println("**************************" + key.toString());
			} catch (IllegalArgumentException | IOException e2) {
				// TODO Auto-generated catch block
				System.out.println("**************************");
				e2.printStackTrace();
			}
			System.out.println(seqReader.toString());
			key = (LongWritable) ReflectionUtils.newInstance(seqReader.getKeyClass(), conf);
			value = (Text) ReflectionUtils.newInstance(seqReader.getValueClass(), conf);
			try {
				while (seqReader.next(key, value)) {
					System.out.printf("%s\t%s\n", key, value);
					context.write(key, value);
				}
			} catch (IOException e1) {
				e1.printStackTrace();
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
		}

	}
	

	/*
	 * 1. 上传文件夹到SequenceFile
	 * 2. 下载SeqenceFile到本地文件夹
	 * 3. 在SequenceFile中查询某些文件，并保存到指定SequenceFile文件中
	 */
	public static void main(String[] args) throws Exception {
		if (args[0].equals("1")) {		// 上传文件或者文件夹（新建一个SequenceFile）
			String localPath = args[1];
//			String remoteSeqFilePath = args[2];
			writeToSequenceFile(localPath);
		} else if (args[0].equals("11")) {		// 进行文件的上传（不存在就新建）
			String localFilePath = args[1];
			uploadSingleTextFile(localFilePath);
		} else if (args[0].equals("12")) {	// 进行文件的追加（在一个已有的文件上追加，不存在就返回失败）
			String localFilePath = args[1];
			String appendedFilePath = args[2];
			appendContent(localFilePath, appendedFilePath);
		} else if (args[0].equals("13")) {	// 上传文件到HDFS（MapFile格式）
			String localPath = args[1];
			writeToMapFile(localPath);
		} else if (args[0].equals("2")) {
			String remoteSeqFilePath = args[1];
			readFromSequenceFile(remoteSeqFilePath);
		} else if (args[0].equals("21")) {
			String remoteFilePath = args[1];
			downloadHDFSFile(remoteFilePath);
		} else if (args[0].equals("22")) {	// 下载MapFile到服务器缓冲目录
			readFromMapFile(args[1]);
		} else if (args[0].equals("23")) {
			downloadHDFSFileParallel(args);
		} else if (args[0].equals("3")) {
			deleteFileInHDFS(args[1]);
		} else if (args[0].equals("4")) {
			extractFiles(args);
		}
		else if (args[0].equals("9")) {
//			String[] pictureNames = args[1].split(",");
//			HashSet<Object> hashSet = new HashSet();
//			for (int i = 0; i < pictureNames.length; i++) {
//				hashSet.add(pictureNames[i]);
//			}
//			System.out.println(hashSet);
			
			String remoteSeqFilePath = "/user/data/test1/data_000001.seq";
			Path path = new Path(remoteSeqFilePath); 
			
			Job job = new Job(conf, "read seq file");
	        job.setJarByClass(HDFSMain.class);  
//	        job.setInputFormatClass(SequenceFileInputFormat.class); 
	        job.setMapperClass(ReadFileMapper.class);  
	        job.setMapOutputValueClass(BytesWritable.class);  	// map输出的格式
	        
//	        fs = FileSystem.get(conf);
//	        seqReader = new SequenceFile.Reader(fs, path, conf);  // path为SequenceFile文件的路径
	        FileInputFormat.addInputPath(job, path);  		// 可以添加多个？？？
	        FileOutputFormat.setOutputPath(job, new Path("/user/data/test1/MRResult"));  
	        System.exit(job.waitForCompletion(true)?0:1);
			
//			JSONObject  dataJson= JSONObject.fromObject(args[1]);
//			Iterator it = dataJson.keys();
//			HashSet<Object> hashSet = new HashSet();
//			while (it.hasNext()) {
//				hashSet.add(dataJson.get(it.next()));
//			}
//			System.out.println(hashSet);
		}

	}


	private static void extractFiles(String[] args) {
		// TODO Auto-generated method stub
		int fileNum = Integer.parseInt(args[1]);
		String[] compressedFileArr = new String[fileNum];
		int argsIndex = 2;
		for (int i = 0; i < fileNum; i++) {
			compressedFileArr[i] = args[argsIndex++];
		}
		
//		HashSet<String> searchTargetSet = new HashSet<String>();
		LinkedList<String> searchTargetList = new LinkedList<String>();
		int searchTargetNum = Integer.parseInt(args[argsIndex++]);
		int searchTargetBeginIndex = argsIndex;
		for (int i = argsIndex; i <= searchTargetBeginIndex+searchTargetNum-1; i++) {
//			System.out.println(args[argsIndex]);
			searchTargetList.add(args[argsIndex++]);
		}
		
		
		try {
			String tmpPathStr = destPrefix + destDirectory + UUID.randomUUID().toString() + ".map"; 		// 加入计算机名和端口号
			Path tmpPath = new Path(tmpPathStr);
			MapFile.Writer writer = new MapFile.Writer(conf, fs, tmpPath.toString(), Text.class, BytesWritable.class);
			for (int i = 0; i < compressedFileArr.length; i++) {
//				extractSpecifiedFiles(compressedFileArr[i], searchTargetList);

				FileSystem fs = FileSystem.get(conf);
				String remoteHDFSFilePath = compressedFileArr[i];
				Path mapFile = new Path(remoteHDFSFilePath);
				Iterator<String> iterator = searchTargetList.iterator();
				while (iterator.hasNext()) {
					String searchTargetStr = iterator.next();
					MapFile.Reader reader = new MapFile.Reader(fs, mapFile.toString(), conf);  
			        Text key=new Text();  
			        BytesWritable bytesWritable = new BytesWritable();
			        //遍历获取结果  
		            while (reader.next(key, bytesWritable)) {		// TODO 优化：在MapFile中直接找是否存在指定文件
		                if (key.toString().equals(searchTargetStr)) {
		                    writer.append(key, bytesWritable);
		                }
		            }
		            //关闭流  
		            IOUtils.closeStream(reader);
		            System.out.println("\n");
				}
			}
			System.out.println("tmpPathStr: " + tmpPathStr);
			writer.close();
			
			downloadHDFSFile(tmpPathStr);		// 将HDFS临时查询出来并合并的文件下载下来
			deleteFileInHDFS(tmpPathStr);		// 下载完成就把临时生成的MapFile删除
		} catch (Exception e){
			e.printStackTrace();
		}
		
	}


	/*
	 * 抽取指定列表的文件，保存到HDFS中，再进行下载
	 */
/*
	private static void extractSpecifiedFiles(String remoteHDFSFilePath, LinkedList<String> searchTargetList) {
		try {
//			FileSystem fs = FileSystem.get(URI.create(remoteHDFSFilePath), conf);
			FileSystem fs = FileSystem.get(conf);
			Path mapFile = new Path(remoteHDFSFilePath);
			Iterator<String> iterator = searchTargetList.iterator();
			while (iterator.hasNext()) {
				String searchTargetStr = iterator.next();
//				System.out.println("searchTargetStr = " + searchTargetStr);
//				System.out.println(mapFile.toString());
				MapFile.Reader reader = new MapFile.Reader(fs, mapFile.toString(), conf);  
//				Reader[] readers = MapFileOutputFormat.getReaders(fs, mapFile, conf);	// 得到要读取MapFile文件的输出数组readers(MapFile.Reader[])。readers是MapFile文件包含的所有输出的一个数组，这些数组中的每一个Reader记录了MapFile中的部分数据，数据在Reader中按照数据对的键(Key)的Hash值进行分布
		        Text key=new Text();  
		        BytesWritable bytesWritable = new BytesWritable();
		        //遍历获取结果  
	            while (reader.next(key, bytesWritable)) {		// TODO 优化：在MapFile中直接找是否存在指定文件
//	                System.out.println("key=" + key);
//	                System.out.println("value=" + bytesWritable);  
	                if (key.toString().equals(searchTargetStr)) {
	                	String destPath = "";
	                	Path tmpPath = new Path(destPath);
	                	MapFile.Writer writer = new MapFile.Writer(conf, fs, tmpPath.toString(), Text.class, BytesWritable.class);
	        			File file1 = new File(srcPath);
	        			byte[] fileByteArray = toByteArray(file1.getAbsolutePath());
	        			BytesWritable bytesWritable = new BytesWritable(fileByteArray);
	        			Text key = new Text();
	        			key.set(file1.getName());
	                    writer.append(key, bytesWritable);
	                    writer.close();
	                    
	                    System.out.println("0");
	                    System.out.println(destPath);
	                    writeContentToFile(uploadListFileName, "0 " + destPath);
	                }
	            }
	            //关闭流  
	            IOUtils.closeStream(reader);
	            System.out.println("\n");
			}
			
			
			//得到指定值所在的reader 
//			Reader[] readers = MapFileOutputFormat.getReaders(fs, mapFile, conf);		// ??????????????????/
//			System.out.println("************************");
//			HashPartitioner<Text, BytesWritable> partitioner = new HashPartitioner<Text, BytesWritable>();
////			Text key = new Text();
//			BytesWritable bytesWritable = new BytesWritable();
//			
//			
////			Iterator<String> iterator = searchTargetList.iterator();
//			System.out.println("************************");
//			while (iterator.hasNext()) {
//				String searchTargetStr = iterator.next();
//				Text searchTarget = new Text(searchTargetStr);
//				int index = partitioner.getPartition(searchTarget, bytesWritable, readers.length);
//				Reader reader = readers[index];
//				//检查是否存在，如果不存在就算了，不再麻烦 了。  
//		        Writable entry = reader.get(searchTarget, bytesWritable); 
//		        if (entry == null) {
//		        	continue;
//		        }
//		        //如果存在，通过遍历的方式得到键为Key的就要得到所有的  
//		        Text nextKey=new Text();  
//		        do{  
//		            System.out.println(bytesWritable.toString());  
//		        }while(reader.next(nextKey, bytesWritable) && searchTarget.equals(nextKey)); 
//			}
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		
//		while (reader.next(key, bytesWritable)) {
//			String fileName = downloadBufferDirectory + "/" + key.toString();
//			FileOutputStream fos = new FileOutputStream(fileName);
//			byte[] copyBytes = bytesWritable.copyBytes();
//			fos.write(copyBytes);						// Get a copy of the bytes that is exactly the length of the data.
//			fos.close();
//		}
	}
*/


	public static void downloadHDFSFileParallel(String[] args) {
		try {
			int downloadFileNUm = Integer.parseInt(args[1]);
			// 如果download.list文件存在，则删除
			File downloadListFile = new File(downloadListFileName);
			if (downloadListFile.exists()) {
				downloadListFile.delete();
			}
			for (int i = 2; i <= downloadFileNUm+1; i++) {
				DownloadHDFSThread downloadHDFSThread = new DownloadHDFSThread(args[i]);
				downloadHDFSThread.start();
			}
		} catch (Exception e) {
			System.out.println("1");
			System.out.println("args wrong");
			writeContentToFile(downloadListFileName, "1 " + "args wrong");
		}
	}
	
	
	public static void downloadHDFSFileParallelBranch(String remoteFilePath) {
		try {
			// 获得远程文件的文件名
			String srcFileName = remoteFilePath.trim();
			String sFileName = srcFileName.substring(srcFileName.lastIndexOf("/")+1);
			String uuid = UUID.randomUUID().toString();
			String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid + "/";
			File mFile = new File(downloadBufferDirectory);
			if (!mFile.exists()) {
				if (!mFile.mkdirs()) {
					System.out.println("1");
					System.out.println("Create directory " + mFile.toString() + " failed!");
					appendContentToFile(downloadListFileName, "1 " + mFile.toString() + " failed!");
				}
			}
			
			// 实例化一个文件系统
			FileSystem fs = FileSystem.get(URI.create(remoteFilePath), conf);
			FileStatus[] fileList = fs.listStatus(new Path(remoteFilePath));
			for (int i = 0; i < fileList.length; i++) {  
	            FileStatus fileStatus = fileList[i];
	            Path singlePath = fileStatus.getPath();
	            // 读出流
				FSDataInputStream HDFS_IN = fs.open(singlePath);
				// 写入流
				String outputPath = downloadBufferDirectory + fileStatus.getPath().getName();
				OutputStream OutToLOCAL = new FileOutputStream(outputPath);
				// 将InputStrteam 中的内容通过IOUtils的copyBytes方法复制到OutToLOCAL中
				IOUtils.copyBytes(HDFS_IN, OutToLOCAL, 1024, true);
	        }
			
			System.out.println("0");
			System.out.println(httpPrefix + uuid + "/");
			appendContentToFile(downloadListFileName, "0 " + httpPrefix + uuid + "/");
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("1");
			System.out.println("HDFS path wrong!");
			appendContentToFile(downloadListFileName, "1 " + "HDFS path wrong!");
		}
	}
	


	public static void downloadHDFSFile(String remoteFilePath) {
		try {
			// 获得远程文件的文件名
			String srcFileName = remoteFilePath.trim();
			String sFileName = srcFileName.substring(srcFileName.lastIndexOf("/")+1);
			String uuid = UUID.randomUUID().toString();
			String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid + "/";
			File mFile = new File(downloadBufferDirectory);
			if (!mFile.exists()) {
				if (!mFile.mkdirs()) {
					System.out.println("1");
					System.out.println("Create directory " + mFile.toString() + " failed!");
					writeContentToFile(downloadListFileName, "1 " + mFile.toString() + " failed!");
				}
			}
			
			// 实例化一个文件系统
			FileSystem fs = FileSystem.get(URI.create(remoteFilePath), conf);
			FileStatus[] fileList = fs.listStatus(new Path(remoteFilePath));
			for (int i = 0; i < fileList.length; i++) {  
	            FileStatus fileStatus = fileList[i];
	            Path singlePath = fileStatus.getPath();
	            // 读出流
				FSDataInputStream HDFS_IN = fs.open(singlePath);
				// 写入流
				String outputPath = downloadBufferDirectory + fileStatus.getPath().getName();
				OutputStream OutToLOCAL = new FileOutputStream(outputPath);
				// 将InputStrteam 中的内容通过IOUtils的copyBytes方法复制到OutToLOCAL中
				IOUtils.copyBytes(HDFS_IN, OutToLOCAL, 1024, true);
	        }
			
			System.out.println("0");
			System.out.println(httpPrefix + uuid + "/");
			writeContentToFile(downloadListFileName, "0 " + httpPrefix + uuid + "/");
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("1");
			System.out.println("HDFS path wrong!");
			writeContentToFile(downloadListFileName, "1 " + "HDFS path wrong!");
		}
	}


	public static void uploadSingleTextFile(String localFilePath) throws IllegalArgumentException, IOException {
		File localFile = new File(localFilePath);
		if (localFile.exists() && localFile.isFile()) {
			String uuid = UUID.randomUUID().toString();
			String targetFullName = destPrefix + destDirectory + uuid;
			FileInputStream fis = new FileInputStream(new File(localFilePath));// 读取本地文件
			Configuration config = new Configuration();
			FileSystem fs = FileSystem.get(URI.create(targetFullName), config);
			OutputStream os = fs.create(new Path(targetFullName));
			// copy
			IOUtils.copyBytes(fis, os, 4096, true);
			System.out.println("0");
			System.out.println(targetFullName);
			writeContentToFile(uploadListFileName, "0 " + targetFullName);
		} else {
			System.out.println("1");
			System.out.println("The argument of local file path wrong!");
			writeContentToFile(uploadListFileName, "1 " + "The argument of local file path wrong!");
		}
		
		
	}


	public static void appendContent(String localFilePath, String appendedFilePath) {
		File localFile = new File(localFilePath);
		if (localFile.exists() && localFile.isFile()) {
			conf.setBoolean("dfs.support.append", true);
			FileSystem fs = null;
			try {
				fs = FileSystem.get(URI.create(appendedFilePath), conf);
				// 要追加的文件流，inpath为文件
				InputStream in = new BufferedInputStream(new FileInputStream(localFilePath));
				OutputStream out = fs.append(new Path(appendedFilePath));
				IOUtils.copyBytes(in, out, 4096, true);
				
				System.out.println("0");
				System.out.println(appendedFilePath);
				writeContentToFile(uploadListFileName, "0 " + appendedFilePath);
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("1");
				System.out.println("HDSF path wrong.");
				writeContentToFile(uploadListFileName, "1 " + "HDSF path wrong.");
			}
		} else {
			System.out.println("1");
			System.out.println("The argument of local file path wrong!");
			writeContentToFile(uploadListFileName, "1 " + "The argument of local file path wrong!");
		}
		
	}
	
	
	/*
	 * 将内容写入文件（如果指定文件名的文件存在，则覆盖）
	 */
	public static void writeContentToFile(String fileName, String content) {
		try {
			BufferedWriter out = new BufferedWriter(new FileWriter(fileName));
			out.write(content);
			out.close();
		} catch (IOException e) {
		}
	}
	
	
	/*
	 * 追加内容到文件末尾
	 * 并发的时候用到追加文件，需要加互斥锁
	 */
	public static synchronized void appendContentToFile(String fileName, String content) {
		try {
			// 打开一个随机访问文件流，按读写方式
			RandomAccessFile randomFile = new RandomAccessFile(fileName, "rw");
			// 文件长度，字节数
			long fileLength = randomFile.length();
			// 将写文件指针移到文件尾。
			randomFile.seek(fileLength);
			randomFile.writeBytes(content + "\r\n");
			randomFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
