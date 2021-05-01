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

	//상품 판매글 등록 화면
	@RequestMapping(value="/newPost")
	public String newPost() {
		log.info(this.getClass().getName() + "판매글 Start!");

		return "/board/newPost";
	}

	//상품 판매글 수정 화면
	@RequestMapping(value="/editPost")
	public String editPost() {
		log.info(this.getClass().getName() + "판매글 수정 Start!");

		return "/boare/editPost";
	}
}
