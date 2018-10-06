package ai.horizon.wanghaidong;

import java.io.File;
import java.util.Comparator;

public class SortByName implements Comparator {

	@Override
	public int compare(Object o1, Object o2) {
		// TODO Auto-generated method stub
		File file1 = (File)o1;
		File file2 = (File)o2;
		return file1.toString().compareTo(file2.toString());
//		return 0;
	}

}
