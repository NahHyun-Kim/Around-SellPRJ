package poly.controller;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import poly.dto.MailDTO;
import poly.service.IMailService;
import static poly.util.CmmUtil.nvl;

@Controller
public class MailController {
	
	private Logger log = Logger.getLogger(this.getClass());
	
	@Resource(name="MailService")
	private IMailService mailService;
	
	@RequestMapping(value="/mail/putmail")
	public String putmail() {
		
		return "/mail/putMail";
	}

	//메일 발송하기
	
	@RequestMapping(value = "/mail/sendMail")
	public String sendMail(HttpServletRequest request, HttpServletResponse response, ModelMap model) throws Exception{
		
		log.info("메일 시작!");
		
		// 웹 url로부터 전달받은 값들
		String toMail = nvl(request.getParameter("toMail")); // 받는사람
		String title = nvl(request.getParameter("title")); //제목
		String contents = nvl(request.getParameter("contents")); // 내용
		
		// 메일 발송할 정보 넣기 위한 DTO 객체 생성하기
		MailDTO pDTO = new MailDTO();
		
		//웹에서 받은 값을 DTO에 넣기
		pDTO.setToMail(toMail);
		pDTO.setTitle(title);
		pDTO.setContents(contents);
		
		log.info("DTO에 set 성공 toMail : " + pDTO.getToMail());
		log.info("contents 받아오나? : " +pDTO.getContents());
		
		//메일발송하기
		int res = mailService.doSendMail(pDTO);
		
		if(res == 1) { // 메일 발송 성공
			log.info("mail.sendMail success!!!");
		}
		else { // 메일발송 실패
			log.info("mail.sendMail fall!!!");
		}
		
		//메일 발송 결과를 jsp에 전달하기(데이터 전달 시, 숫자보단 문자열이 컨트롤하기 편리하기 때문에 강제로 숫자를 문자로 변환함)
		model.addAttribute("res",String.valueOf(res));
		
		log.info("메일 전송 완료");
		
		return "/mail/sendMailResult";
	}
}
