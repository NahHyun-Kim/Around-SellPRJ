package poly.controller;

import org.apache.log4j.Logger;
import org.aspectj.weaver.ast.Not;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.NoticeDTO;
import poly.service.INoticeService;
import poly.util.CmmUtil;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Array;
import java.util.*;


@Controller
public class MainController {

	private Logger log = Logger.getLogger(this.getClass());

	/*
	 * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
	 * NoticeService(INoticeService 사용)
	 * */
	@Resource(name = "NoticeService")
	private INoticeService noticeService;

	//홈페이지(index) 화면
	@RequestMapping(value = "index")
	public String Index() {
		log.info(this.getClass());

		return "/index";
	}

	@RequestMapping(value = "test")
	public String test() {
		log.info("워드 클라우드 테스트 화면");
		return "/wordcloud/test";
	}

	// 워드 클라우드 구현을 위한 판매상품 빈도수 체크
	/*
	 * @ReseponseBody를 통해 명시적으로 produces를 사용해서 utf-8로 인코딩하면, ajax에 결과값 전송 시
	 * 오류 없이 전송된다(json 타입으로 반환할 경우에는 application/json 으로 설정하면 된다.)
	 * 원인 : applicationContext의 MessageConverter에서 최종 다른 캐릭터셋으로 덮어씌우기 때문
	 */
	@ResponseBody
	@RequestMapping(value = "/titleCount", produces = "application/text; charset=utf8")
	public String titleCount(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		log.info("titleCount Start!");

		// 지역구가 있다면 지역구에 해당하는 판매 글을 불러오고, 로그인 상태가 아니라면 전체 판매글을 불러옴
		String addr2 = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR2"), "none");
		log.info("로그인 안하면 'none'으로 뜸, 로그인 하면 지역구 표시 : " + addr2);

		NoticeDTO pDTO = new NoticeDTO();
		pDTO.setAddr2(addr2);

		// 판매글 리스트를 가져온다.
		List<NoticeDTO> rList = noticeService.getNoticeList(pDTO);

		log.info("rList 가져왔는지(isNull) ? : " + (rList == null));

		// 판매글 중 상품명을 담을 변수와 리스트 배열 생성
		String title = "";
		//List<String> titleList = new ArrayList<>();
		String titles = "";

		/*for (NoticeDTO i : rList) {
			// 상품명에 문자가 아닌 기호가 있다면, 제거
			title = i.getGoods_title().replace(":", "").replace("(", "").replace(")", "").replace(":", "");
			log.info("가져온 상품명 : " + title);

			titles += title + " ";

			//titleList.add(title);
		} */

		String[] splitTitle = titles.split(" ");
		log.info(splitTitle[0] + " " + splitTitle[1]);

		Map<String, Integer> hs = new HashMap<>();

		// 단어 빈도수 체크하기
		for (int i = 0; i < splitTitle.length; i++) {

			// 키가 존재하면, 해당 키의 value를 +1 함
			if (hs.containsKey(splitTitle[i])) {
				hs.put(splitTitle[i], hs.get(splitTitle[i]) + 1);

			} else { // 키가 없다면, 단어(key)와 value를 1로 초기화한다.
				hs.put(splitTitle[i], 1);
			}

		}

		String titleCnt = "";

		/* 단어 빈도수 출력 */
		for (String key : hs.keySet()) {
			titleCnt += "{\"tag\": \"" + key + "\", \"count\": \"" + hs.get(key) + "\"},";
		}

		// 한글깨짐 방지를 위해 인코딩하기
		// URLEncoder.encode(titleCnt , "UTF-8");

		titleCnt = titleCnt.substring(0, titleCnt.length() - 1); // 마지막에 붙은 따옴표 제거
		String result = "[" + titleCnt + "]";

		System.out.println("count 형태로 변경한 데이터 : " + result);
		pDTO = null;
		//JSONParser jsonParser = new JSONParser();

		//JSONObject jsonObj = (JSONObject) jsonParser.parse(result);

		return result;
	}

	// 카테고리 별로 조회수가 가장 많은 5개 상품을 뽑아와서 보여준다.
	@ResponseBody
	@RequestMapping(value="/maxCount", produces = "application/text; charset=utf8")
	public String maxCount(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
		
		log.info(this.getClass().getName() + ".maxCount(인기순 카테고리 불러오기 시작!");
		
		String addr2 = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR2"),"none");
		log.info("받아온 회원번호(비 로그인이면 None)" + addr2);
		
		// getNoticeList에 pDTO를 추가해서 보낸다. try, catch로 addr 세팅해서 보내주기

		
		String result = "";


		return result;
	}

	// 카테고리별 게시물수 가져오기
	@ResponseBody
	@RequestMapping(value="/cateCount", produces = "application/text; charset=utf8")
	public String cateCount(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		log.info(this.getClass().getName() + ".cateCount(카테고리별 게시글수 시각화)");

		// 지역구가 있다면 지역구에 해당하는 판매 글을 불러오고, 로그인 상태가 아니라면 전체 판매글을 불러옴
		String addr2 = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR2"), "none");
		log.info("로그인 안하면 'none'으로 뜸, 로그인 하면 지역구 표시 : " + addr2);

		NoticeDTO pDTO = new NoticeDTO();
		pDTO.setAddr2(addr2);

		// 판매글 리스트 가져오기
		// 판매글 정보는 여러개이므로, DTO를 List 형태에 담아 반환한다.
		List<NoticeDTO> rList = noticeService.cateCount(pDTO);

		if (rList == null) {
			rList = new ArrayList<NoticeDTO>();

		}

		String cateCnt = "";

		for (NoticeDTO i : rList) {
			cateCnt += "{\"category\": \"" + i.getCategory() + "\", \"cnt\": \"" + i.getCnt() + "\"},";
		}

		cateCnt = cateCnt.substring(0, cateCnt.length() - 1); // 마지막에 붙은 따옴표 제거
		String result = "[" + cateCnt + "]"; // 파이차트가 요구하는 데이터 형태, 배열 형태로 만들어줌

		/*JSONParser jsonParser = new JSONParser();
		//기본적으로 숫자에 대해 오름차순으로 자동 정렬을 한다고 한다. 그래서 형식에 맞는 cnt가 앞으로 가서 오름차순으로 정렬됨..
		JSONArray jsonArr = (JSONArray) jsonParser.parse(result);
		System.out.println("jsonArr " + jsonArr); */

		System.out.println("result(카테고리별 카운트) : " + result);
		log.info(this.getClass().getName() + ".cateCount(카테고리별 게시글수 시각화) 끝!");

		return result;
	}

	// 카테고리별 게시물수 가져오기
	@ResponseBody
	@RequestMapping(value="/cateCount2", produces = "application/text; charset=utf8")
	public String cateCount2(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		log.info(this.getClass().getName() + ".cateCount2(카테고리별 게시글수 시각화)");

		// 지역구가 있다면 지역구에 해당하는 판매 글을 불러오고, 로그인 상태가 아니라면 전체 판매글을 불러옴
		String addr2 = CmmUtil.nvl((String) session.getAttribute("SS_USER_ADDR2"), "none");
		log.info("로그인 안하면 'none'으로 뜸, 로그인 하면 지역구 표시 : " + addr2);

		NoticeDTO pDTO = new NoticeDTO();
		pDTO.setAddr2(addr2);

		// 판매글 리스트 가져오기
		// 판매글 정보는 여러개이므로, DTO를 List 형태에 담아 반환한다.
		List<NoticeDTO> rList = noticeService.cateCount(pDTO);

		if (rList == null) {
			rList = new ArrayList<NoticeDTO>();

		}

		String cateCnt = "";

		for (NoticeDTO i : rList) {
			cateCnt += "{\"category\": \"" + i.getCategory() + "\", \"cnt\": \"" + i.getCnt() + "\"},";
		}

		cateCnt = cateCnt.substring(0, cateCnt.length() - 1); // 마지막에 붙은 따옴표 제거
		String result =
				"[{\n" +
				"    \"category\": \"Dummy\",\n" +
				"    \"disabled\": \"true\",\n" +
				"    \"cnt\": \"1000\",\n" +
				"    \"color\": \"am4core.color(\'#dadada\')\",\n" +
				"    \"opacity\": \"0.3\",\n" +
				"    \"strokeDasharray\": \"4,4\"\n" +
				"}," + cateCnt + "]"; // 파이차트가 요구하는 데이터 형태, 배열 형태로 만들어줌

		/*JSONParser jsonParser = new JSONParser();
		//기본적으로 숫자에 대해 오름차순으로 자동 정렬을 한다고 한다. 그래서 형식에 맞는 cnt가 앞으로 가서 오름차순으로 정렬됨..
		JSONArray jsonArr = (JSONArray) jsonParser.parse(result);
		System.out.println("jsonArr " + jsonArr); */

		System.out.println("result(카테고리별 카운트) : " + result);
		log.info(this.getClass().getName() + ".cateCount2(카테고리별 게시글수 시각화) 끝!");

		return result;
	}


	// 인기순 워드클라우드
	/*@ResponseBody
	@RequestMapping(value="/HitCount",  produces = "application/text; charset=utf8")
	public String HitCount(HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info("HitCount Start!");

		// 판매글 리스트를 가져온다.
		List<NoticeDTO> rList = noticeService.getNoticeList();

		log.info("rList 가져왔는지(isNull) ? : " + (rList == null));

		// 판매글 중 상품명과 조회수를 담을 변수와 리스트 배열 생성
		String title = "";
		int hit = 0;

		for (NoticeDTO i : rList) {
			// 상품명에 문자가 아닌 기호가 있다면, 제거
			title = i.getGoods_title().replace(":", "").replace("(", "").replace(")", "").replace(":", "");
			log.info("가져온 상품명 : " + title);

			titles += title + " ";

			//titleList.add(title);
		}

		String[] splitTitle = titles.split(" ");
		log.info(splitTitle[0] + " " + splitTitle[1]);

		Map<String, Integer> hs = new HashMap<>();

		// 단어 빈도수 체크하기
		for (int i = 0; i < splitTitle.length; i++) {

			// 키가 존재하면, 해당 키의 value를 +1 함
			if (hs.containsKey(splitTitle[i])) {
				hs.put(splitTitle[i], hs.get(splitTitle[i]) + 1);

			} else { // 키가 없다면, 단어(key)와 value를 1로 초기화한다.
				hs.put(splitTitle[i], 1);
			}

		}

		String titleCnt = "";

		// 단어 빈도수 출력
		for (String key : hs.keySet()) {
			titleCnt += "{\"tag\": \"" + key + "\", \"count\": \"" + hs.get(key) +"\"},";
		}

		// 한글깨짐 방지를 위해 인코딩하기
		// URLEncoder.encode(titleCnt , "UTF-8");

		titleCnt = titleCnt.substring(0,titleCnt.length()-1); // 마지막에 붙은 따옴표 제거
		//String result = "[" + titleCnt + "]";

		System.out.println("count 형태로 변경한 데이터 : " + titleCnt);
		return titleCnt;
	} 

	// 
	 */

}