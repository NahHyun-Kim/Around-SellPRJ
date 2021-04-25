package poly.util;

public class NumberUtil {

	/**
	 * 소수점 자릿수 반환하기
	 */
	public static double getNumberRound(double stdNumber, double dataSize) {
		return Math.round(stdNumber * dataSize) / dataSize;
	}
	
	/* Wrapper 객체로 선언된 숫자형태 데이터를 강제로 형변환하기 */
	/**
	 * long 타입 변환하기
	 */
	public static long getLong(Object num) {
		Number res = (Number) num;
		return res.longValue();
	}

	/**
	 * int 타입 변환하기
	 */
	public static int getInt(Object num) {
		Number res = (Number) num;
		return res.intValue();
	}

	/**
	 * double 타입 변환하기
	 */
	public static double getDouble(Object num) {
		Number res = (Number) num;
		return res.doubleValue();
	}

	/**
	 * float 타입 변환하기
	 */
	public static float getFloat(Object num) {
		Number res = (Number) num;
		return res.floatValue();
	}

}
