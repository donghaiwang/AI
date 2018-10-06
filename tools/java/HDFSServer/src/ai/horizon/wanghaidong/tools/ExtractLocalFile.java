package ai.horizon.wanghaidong.tools;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URI;
import java.util.UUID;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.MapFile;
import org.apache.hadoop.io.SequenceFile;
import org.apache.hadoop.io.Text;

public class ExtractLocalFile {
	
	public static Configuration conf = new Configuration();
	
	private static String extractFileName = "extract.list";
	
	public static int extractMapFile(String localFilePath) {
		conf.set("fs.default.name", "file:///");  
		conf.set("mapred.job.tracker", "local");	//���ö�ȡ���ش����ļ�
		
//		UUID uuid = UUID.randomUUID();
//		String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid.toString() + "/";
		String extractDestPath = "extract";
		File extractDestFile = new File(extractDestPath);
		if (!extractDestFile.exists()) {
			if (!extractDestFile.mkdirs()) {
				System.out.println("1");
				System.out.println("Create directory " + extractDestFile.toString() + " failed!");
				writeContentToFile(extractFileName, "1 " + "Create directory " + extractDestFile.toString() + " failed!");
				return 1;
			}
		} else {
			boolean isDelete = deleteDir(new File(extractDestFile.getAbsolutePath()));
			if (!extractDestFile.mkdirs() || isDelete == false) {
				System.out.println("1");
				System.out.println("Create directory " + extractDestFile.toString() + " failed!");
				writeContentToFile(extractFileName, "1 " + "Create directory " + extractDestFile.toString() + " failed!");
			}
		}
		
		File localMapFile = new File(localFilePath);
		if (localMapFile.isDirectory()) {		// ��Ŀ¼��ʾ��MapFile
			try {
				FileSystem fs = FileSystem.get(URI.create(localFilePath), conf);
				Path mapFile = new Path(localFilePath);
				MapFile.Reader reader=new MapFile.Reader(fs, mapFile.toString(), conf); 
				Text key = new Text();
				BytesWritable bytesWritable = new BytesWritable();
				while (reader.next(key, bytesWritable)) {
					String fileName = extractDestPath + "/" + key.toString();
					FileOutputStream fos = new FileOutputStream(fileName);
					byte[] copyBytes = bytesWritable.copyBytes();
					fos.write(copyBytes);						// Get a copy of the bytes that is exactly the length of the data.
					fos.close();
				}
				reader.close();
				System.out.println("0");
				writeContentToFile(extractFileName, "0 " + extractFileName);
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println("1");
				System.out.println("HDFS path wrong!");
				writeContentToFile(extractFileName, "1 " + "HDFS path wrong!");
			}
		} else if (localMapFile.isFile()) {
			System.out.println(localMapFile.toString());
			
//			UUID uuid = UUID.randomUUID();
//			String downloadBufferDirectory = downloadBufferDirectoryPrefix + uuid.toString() + "/";
			File mFile = new File(extractDestPath);
			
			try {
				FileSystem fs = FileSystem.get(URI.create(localFilePath), conf);
				SequenceFile.Reader reader = new SequenceFile.Reader(fs, new Path(localFilePath), conf);
				Text key = new Text();
//				int fileLength = (int) fs.getLength(new Path(remoteSeqFilePath));
				BytesWritable bytesWritable = new BytesWritable();
				while (reader.next(key, bytesWritable)) {
//					System.out.println(key);
					String fileName = extractDestPath + "/" + key.toString();
					FileOutputStream fos = new FileOutputStream(fileName);
					byte[] copyBytes = bytesWritable.copyBytes();
					fos.write(copyBytes);						// Get a copy of the bytes that is exactly the length of the data.
					fos.close();
				}
				System.out.println("0");
				System.out.println(extractDestPath + "/");
				writeContentToFile(extractFileName, "0 " + extractDestPath + "/");
			} catch (IOException e) {
				System.out.println("1");
				System.out.println("HDFS path wrong!");
				writeContentToFile(extractFileName, "1 " + "HDFS path wrong!");
			}
		}
		
		
		
		return 0;
	}
	
	/**
     * �ݹ�ɾ��Ŀ¼�µ������ļ�����Ŀ¼�������ļ�
     * @param dir ��Ҫɾ�����ļ�Ŀ¼
     * @return boolean Returns "true" if all deletions were successful.
     *                 If a deletion fails, the method stops attempting to
     *                 delete and returns "false".
     */
    private static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i=0; i<children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }
        // Ŀ¼��ʱΪ�գ�����ɾ��
        return dir.delete();
    }

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		extractMapFile(args[0]);
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

}

