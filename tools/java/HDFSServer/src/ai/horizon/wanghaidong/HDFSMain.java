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
			destPath = destPrefix + destPath; 		// �����������Ͷ˿ں�
			Path path = new Path(destPath);	// ����ϴ����ǵ����ļ���seq�ļ�����ԭ���ļ���һ��
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
			destPath = destPrefix + destPath;		// �����������Ͷ˿ں�
			Path path = new Path(destPath);	// ����ϴ�����һ��Ŀ¼��seq�ļ���ʹ��UUID���ɣ�������ļ������ֲ���
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
			destPath = destPrefix + destPath; 		// �����������Ͷ˿ں�
			Path path = new Path(destPath);	// ����ϴ����ǵ����ļ���seq�ļ�����ԭ���ļ���һ��
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
			destPath = destPrefix + destPath;		// �����������Ͷ˿ں�
			Path path = new Path(destPath);	// ����ϴ�����һ��Ŀ¼��seq�ļ���ʹ��UUID���ɣ�������ļ������ֲ���
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
        // 1.��ȡ��Ŀ¼
        File[] files = mFile.listFiles();
        // 2.�ж�files�Ƿ��ǿյ� ����������
        if (files != null) {
            for (File file : files) {
                if (file.isDirectory()) {
                    getAllFile(file, mlist);//���õݹ�ķ�ʽ
                } else {
                    // 4. ��ӵ�������ȥ
                    String fileName = file.getName();
                    if (fileName.endsWith(".jpg") || fileName.endsWith(".png")
                            || fileName.endsWith(".gif")) {
                        mlist.add(file);//������⼸��ͼƬ��ʽ����ӽ�ȥ
                    }
                }
            }
        }
	}
	
	
	/** 
     * Mapped File way MappedByteBuffer �����ڴ�����ļ�ʱ���������� 
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
//        seqReader = new SequenceFile.Reader(fs, path, conf);  // pathΪSequenceFile�ļ���·��
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
	 * 1. �ϴ��ļ��е�SequenceFile
	 * 2. ����SeqenceFile�������ļ���
	 * 3. ��SequenceFile�в�ѯĳЩ�ļ��������浽ָ��SequenceFile�ļ���
	 */
	public static void main(String[] args) throws Exception {
		if (args[0].equals("1")) {		// �ϴ��ļ������ļ��У��½�һ��SequenceFile��
			String localPath = args[1];
//			String remoteSeqFilePath = args[2];
			writeToSequenceFile(localPath);
		} else if (args[0].equals("11")) {		// �����ļ����ϴ��������ھ��½���
			String localFilePath = args[1];
			uploadSingleTextFile(localFilePath);
		} else if (args[0].equals("12")) {	// �����ļ���׷�ӣ���һ�����е��ļ���׷�ӣ������ھͷ���ʧ�ܣ�
			String localFilePath = args[1];
			String appendedFilePath = args[2];
			appendContent(localFilePath, appendedFilePath);
		} else if (args[0].equals("13")) {	// �ϴ��ļ���HDFS��MapFile��ʽ��
			String localPath = args[1];
			writeToMapFile(localPath);
		} else if (args[0].equals("2")) {
			String remoteSeqFilePath = args[1];
			readFromSequenceFile(remoteSeqFilePath);
		} else if (args[0].equals("21")) {
			String remoteFilePath = args[1];
			downloadHDFSFile(remoteFilePath);
		} else if (args[0].equals("22")) {	// ����MapFile������������Ŀ¼
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
	        job.setMapOutputValueClass(BytesWritable.class);  	// map����ĸ�ʽ
	        
//	        fs = FileSystem.get(conf);
//	        seqReader = new SequenceFile.Reader(fs, path, conf);  // pathΪSequenceFile�ļ���·��
	        FileInputFormat.addInputPath(job, path);  		// ������Ӷ��������
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
			String tmpPathStr = destPrefix + destDirectory + UUID.randomUUID().toString() + ".map"; 		// �����������Ͷ˿ں�
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
			        //������ȡ���  
		            while (reader.next(key, bytesWritable)) {		// TODO �Ż�����MapFile��ֱ�����Ƿ����ָ���ļ�
		                if (key.toString().equals(searchTargetStr)) {
		                    writer.append(key, bytesWritable);
		                }
		            }
		            //�ر���  
		            IOUtils.closeStream(reader);
		            System.out.println("\n");
				}
			}
			System.out.println("tmpPathStr: " + tmpPathStr);
			writer.close();
			
			downloadHDFSFile(tmpPathStr);		// ��HDFS��ʱ��ѯ�������ϲ����ļ���������
			deleteFileInHDFS(tmpPathStr);		// ������ɾͰ���ʱ���ɵ�MapFileɾ��
		} catch (Exception e){
			e.printStackTrace();
		}
		
	}


	/*
	 * ��ȡָ���б���ļ������浽HDFS�У��ٽ�������
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
//				Reader[] readers = MapFileOutputFormat.getReaders(fs, mapFile, conf);	// �õ�Ҫ��ȡMapFile�ļ����������readers(MapFile.Reader[])��readers��MapFile�ļ����������������һ�����飬��Щ�����е�ÿһ��Reader��¼��MapFile�еĲ������ݣ�������Reader�а������ݶԵļ�(Key)��Hashֵ���зֲ�
		        Text key=new Text();  
		        BytesWritable bytesWritable = new BytesWritable();
		        //������ȡ���  
	            while (reader.next(key, bytesWritable)) {		// TODO �Ż�����MapFile��ֱ�����Ƿ����ָ���ļ�
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
	            //�ر���  
	            IOUtils.closeStream(reader);
	            System.out.println("\n");
			}
			
			
			//�õ�ָ��ֵ���ڵ�reader 
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
//				//����Ƿ���ڣ���������ھ����ˣ������鷳 �ˡ�  
//		        Writable entry = reader.get(searchTarget, bytesWritable); 
//		        if (entry == null) {
//		        	continue;
//		        }
//		        //������ڣ�ͨ�������ķ�ʽ�õ���ΪKey�ľ�Ҫ�õ����е�  
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
			// ���download.list�ļ����ڣ���ɾ��
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
			// ���Զ���ļ����ļ���
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
			
			// ʵ����һ���ļ�ϵͳ
			FileSystem fs = FileSystem.get(URI.create(remoteFilePath), conf);
			FileStatus[] fileList = fs.listStatus(new Path(remoteFilePath));
			for (int i = 0; i < fileList.length; i++) {  
	            FileStatus fileStatus = fileList[i];
	            Path singlePath = fileStatus.getPath();
	            // ������
				FSDataInputStream HDFS_IN = fs.open(singlePath);
				// д����
				String outputPath = downloadBufferDirectory + fileStatus.getPath().getName();
				OutputStream OutToLOCAL = new FileOutputStream(outputPath);
				// ��InputStrteam �е�����ͨ��IOUtils��copyBytes�������Ƶ�OutToLOCAL��
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
			// ���Զ���ļ����ļ���
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
			
			// ʵ����һ���ļ�ϵͳ
			FileSystem fs = FileSystem.get(URI.create(remoteFilePath), conf);
			FileStatus[] fileList = fs.listStatus(new Path(remoteFilePath));
			for (int i = 0; i < fileList.length; i++) {  
	            FileStatus fileStatus = fileList[i];
	            Path singlePath = fileStatus.getPath();
	            // ������
				FSDataInputStream HDFS_IN = fs.open(singlePath);
				// д����
				String outputPath = downloadBufferDirectory + fileStatus.getPath().getName();
				OutputStream OutToLOCAL = new FileOutputStream(outputPath);
				// ��InputStrteam �е�����ͨ��IOUtils��copyBytes�������Ƶ�OutToLOCAL��
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
			FileInputStream fis = new FileInputStream(new File(localFilePath));// ��ȡ�����ļ�
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
				// Ҫ׷�ӵ��ļ�����inpathΪ�ļ�
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
	 * ������д���ļ������ָ���ļ������ļ����ڣ��򸲸ǣ�
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
	 * ׷�����ݵ��ļ�ĩβ
	 * ������ʱ���õ�׷���ļ�����Ҫ�ӻ�����
	 */
	public static synchronized void appendContentToFile(String fileName, String content) {
		try {
			// ��һ����������ļ���������д��ʽ
			RandomAccessFile randomFile = new RandomAccessFile(fileName, "rw");
			// �ļ����ȣ��ֽ���
			long fileLength = randomFile.length();
			// ��д�ļ�ָ���Ƶ��ļ�β��
			randomFile.seek(fileLength);
			randomFile.writeBytes(content + "\r\n");
			randomFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}
