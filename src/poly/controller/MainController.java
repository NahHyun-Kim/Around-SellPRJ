package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import poly.dto.NoticeDTO;
import poly.service.INoticeService;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
public class MainController {
	
	private Logger log = Logger.getLogger(this.getClass());

	/*
	 * 비즈니스 로직(중요 로직을 수행하기 위해 사용되는 서비스를 싱글톤패턴으로 메모리에 적재
	 * NoticeService(INoticeService 사용)
	 * */
	@Resource(name="NoticeService")
	private INoticeService noticeService;

	//홈페이지(index) 화면
	@RequestMapping(value="index")
	public String Index() {
		log.info(this.getClass());

		return "/index";
	}

	@RequestMapping(value="test")
	public String test() {
		log.info("워드 클라우드 테스트 화면");
		return "/wordcloud/test";
	}

	@ResponseBody
	@RequestMapping(value="/titleCount")
	public Map<String, Integer> titleCount(HttpServletRequest request, HttpServletResponse response) throws Exception {

		log.info("titleCount Start!");

		// 판매글 리스트를 가져온다.
		List<NoticeDTO> rList = noticeService.getNoticeList();

		log.info("rList 가져왔는지(isNull) ? : " + (rList == null));

		// 판매글 중 상품명을 담을 변수와 리스트 배열 생성
		String title = "";
		//List<String> titleList = new ArrayList<>();
		String titles = "";

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
		/* 단어 빈도수 출력 */
		for (String key : hs.keySet()) {
			System.out.println(key + ": " + hs.get(key));
		}

		return hs;
	}
}
