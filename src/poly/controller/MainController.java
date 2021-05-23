package poly.controller;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class MainController {
	
	private Logger log = Logger.getLogger(this.getClass());

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

}
