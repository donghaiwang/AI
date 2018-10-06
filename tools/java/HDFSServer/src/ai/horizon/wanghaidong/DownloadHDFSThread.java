package ai.horizon.wanghaidong;

public class DownloadHDFSThread extends Thread {
	String hdfsFilePath;
	
	public DownloadHDFSThread(String hdfsFilePath) {
		super();
		this.hdfsFilePath = hdfsFilePath;
	}

	public void run() {
//		System.out.println("hello " + hdfsFilePath);
		HDFSMain.downloadHDFSFileParallelBranch(hdfsFilePath);
	}
}
