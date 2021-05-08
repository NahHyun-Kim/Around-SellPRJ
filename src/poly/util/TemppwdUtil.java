package poly.util;

import java.util.Random;

public class TemppwdUtil {

    public static String SendTemporaryMail() {
        // 랜덤 생성 메서드
        Random rand = new Random();
        // 랜덤 값 담을 변수
        StringBuffer strBu = new StringBuffer();
        String result = "";
        // 반복문으로 8자리 생성 대문자, 소문자, 숫자 케이스 3개
        for (int i = 0; i < 8; i++) {
            int index = rand.nextInt(3);
            switch (index) {
                case 0:
                    strBu.append((char)(rand.nextInt(26)+97));
                    break;
                case 1:
                    strBu.append((char)(rand.nextInt(26)+65));
                    break;
                case 2:
                    strBu.append(rand.nextInt(10));
                    break;
            }
        }
        // 스트링버퍼를 스트링으로 변환
        result = strBu.toString();
        // 값 담아 리턴
        return result;
    }

}
