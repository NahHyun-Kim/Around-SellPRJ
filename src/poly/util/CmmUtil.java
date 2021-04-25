package poly.util;

public class CmmUtil {
	public static String nvl(String str, String chg_str) {
		String res;

		if (str == null) {
			res = chg_str;
		} else if (str.equals("")) {
			res = chg_str;
		} else {
			res = str;
		}
		return res;
	}

	public static String nvl(String str) {
		return nvl(str, "");
	}

	public static String checked(String str, String com_str) {
		if (str.equals(com_str)) {
			return " checked";
		} else {
			return "";
		}
	}

	public static String checked(String[] str, String com_str) {
		for (int i = 0; i < str.length; i++) {
			if (str[i].equals(com_str))
				return " checked";
		}
		return "";
	}

	public static String select(String str, String com_str) {
		if (str.equals(com_str)) {
			return " selected";
		} else {
			return "";
		}
	}

	public static String getFileNm(String fileFullPath) {
		int pos = fileFullPath.lastIndexOf("/"); // 리눅스 운영체제용

		if (pos < 1) { // 윈도우 운영체제용
			pos = fileFullPath.lastIndexOf("\\");
		}

		String fileName = fileFullPath.substring(pos + 1, fileFullPath.length());

		return nvl(fileName);

	}

	/**
	 * 숫자 타입으로 변환(Long)
	 * 
	 */
	public static long nvl(Object obj, long num) {
		long res = 0;

		if (obj == null) {
			res = num;

		} else {
			res = (long) obj;

		}

		return res;
	}

	/**
	 * 숫자 타입으로 변환(Long)
	 * 
	 */
	public static long nvl(Object obj) {
		return nvl(obj, 0);
	}

	/**
	 * 숫자 타입으로 변환(Long)
	 * 
	 */
	public static double nvl(Object obj, double num) {
		double res = 0;

		if (obj == null) {
			res = num;

		} else {
			res = (double) obj;

		}

		return res;
	}

	/**
	 * 한자리 숫자가 입력되면 앞에 영붙이기
	 * 
	 * @param 앞에  0붙일 숫자
	 * @param 자릿수
	 * 
	 * @return 0붙은 숫자(문자열)
	 */
	public static String fmNumber(int num) {
		return fmNumber(num, 3);

	}

	/**
	 * 한자리 숫자가 입력되면 앞에 영붙이기
	 * 
	 * @param 앞에  0붙일 숫자
	 * @param 자릿수
	 * 
	 * @return 0붙은 숫자(문자열)
	 */
	public static String fmNumber(int num, int cnt) {
		return String.format("%0" + cnt + "d", num);

	}

}
