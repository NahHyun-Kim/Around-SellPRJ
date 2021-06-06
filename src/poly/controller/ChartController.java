package poly.controller;

import org.apache.log4j.Logger;
import org.aspectj.weaver.ast.Not;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
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
public class ChartController {

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
		log.info("부트스트랩 테스트 화면");
		return "/test";
	}

	/*
	 * @ReseponseBody를 통해 명시적으로 produces를 사용해서 utf-8로 인코딩하면, ajax에 결과값 전송 시
	 * 오류 없이 전송된다(json 타입으로 반환할 경우에는 application/json 으로 설정하면 된다.)
	 * 원인 : applicationContext의 MessageConverter에서 최종 다른 캐릭터셋으로 덮어씌우기 때문
	 */
	@ResponseBody
	@RequestMapping(value = "/titleCount", produces = "application/json; charset=utf8")
	public JSONArray titleCount(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

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
		//String titles = "";

		for (NoticeDTO i : rList) {
			// 상품명에 문자가 아닌 기호가 있다면, 제거
			title += i.getGoods_title().replace(":", "").replace("(", "").replace(")", "").replace(":", "") + " ";
			// log.info("가져온 상품명 : " + title);
			// titles += title + " ";

		}

		// 공백으로 상품명을 구분해서 배열에 담음
		//String[] splitTitle = titles.split(" ");
		String[] splitTitle = title.split(" ");

		// 워드 카운트(빈도수 체크) 값을 담을 HashMap 생성
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

		// jsonObject를 [ {}, {} ] 형태로 담을 배열형태의 JSONArray 생성
		JSONArray jsonArray = new JSONArray();

		// entrySet()은 value, key값을 모두 이용할 때 사용
		hs.entrySet().stream().forEach(entry -> {
			// wordCount에서 요구하는 {"tag" : "키값", "count" : "워드카운트 빈도수"} 형태로 object에 put

			JSONObject jsonObject = new JSONObject();
			/* key값(상품명)을 "tag"의 value값으로 put
			 * value값(빈도수)을 "count"의 value값으로 put -> int형을 String으로 형변환( "" 형태 사용) */
			jsonObject.put("tag", entry.getKey());
			jsonObject.put("count", String.valueOf(entry.getValue()));

			// jsonArray에 요소 추가
			jsonArray.add(jsonObject);
		});

		log.info("jsonArray 만든 형태(WordCount) 출력 : " + jsonArray.toJSONString());

		response.setStatus(HttpServletResponse.SC_ACCEPTED);

		return jsonArray;
	}

	// 카테고리별 게시물수 가져오기
	@ResponseBody
	@RequestMapping(value="/cateCount", produces = "application/json; charset=utf8")
	public JSONArray cateCount(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

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

		Iterator<NoticeDTO> it = rList.iterator();

		// [ {"category" : "카테고리명", "cnt" : "게시글수"} , {}... ] 형태로 json Array를 반환해야 함
		JSONArray cntArray = new JSONArray();

		while (it.hasNext()) {
			NoticeDTO result = it.next();

			JSONObject cntObject = new JSONObject();
			cntObject.put("category", result.getCategory());
			cntObject.put("cnt", result.getCnt());

			cntArray.add(cntObject);
		}

		log.info("Category Count(일반 파이차트) 배열 : " + cntArray.toJSONString());

		return cntArray;
	}

	// 카테고리별 게시물수 가져오기
	@ResponseBody
	@RequestMapping(value="/cateCount2")
	public List<NoticeDTO> cateCount2(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

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

		// javascript에서 json 파싱(amchart draggable 가능한 차트에서 옵션 함께 추가)
		return rList;
	}

	// 카테고리 별로 조회수가 가장 많은 5개 상품을 뽑아와서 보여준다.
	@ResponseBody
	@RequestMapping(value="/hitProduct")
	public List<NoticeDTO> maxCount(HttpServletRequest request, HttpServletResponse response, HttpSession session,
									@RequestParam(value="category", defaultValue = "none") String category) throws Exception {

		log.info(this.getClass().getName() + ".hitProduct(인기순 카테고리 불러오기 시작!");


		// getNoticeList에 pDTO를 추가해서 보낸다. try, catch로 addr 세팅해서 보내주기
		NoticeDTO pDTO = new NoticeDTO();

		log.info("카테고리 받아왔나 : " + category);
		pDTO.setCategory(category);

		List<NoticeDTO> rList = noticeService.hitProduct(pDTO);
		log.info("rList 받아왔나 : " + (rList == null));

		pDTO = null;

		// ajax로 rList값 리턴 (사용할 것 : 이미지 주소, 상품명, 조회수)
		// rList를 javascript에서 파싱 예정
		log.info(this.getClass().getName() + ".hitProduct(인기순 카테고리 불러오기 끝!");
		return rList;
	}

	// 로그인/회원가입 시 디자인용으로 띄울 워드 클라우드
	@ResponseBody
	@RequestMapping(value = "/titleAll", produces = "application/json; charset=utf8")
	public String titleAll(HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {

		log.info("titleAll Start!");

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
		//String titles = "";

		for (NoticeDTO i : rList) {
			// 상품명에 문자가 아닌 기호가 있다면, 제거
			title += i.getGoods_title().replace(":", "").replace("(", "").replace(")", "").replace(":", "") + " ";
		}

		log.info("title 모음 : " + title);

		return title;
	}

}