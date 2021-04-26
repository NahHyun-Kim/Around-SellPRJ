package poly.service.impl;

import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.MailDTO;
import poly.service.IMailService;
import poly.util.CmmUtil;

@Service("MailService")
public class MailService implements IMailService {

	private Logger log =Logger.getLogger(this.getClass());
	
	final String host = "smtp.naver.com";
	final String user = "";
	final String password = "";

	@Override
	public int doSendMail(MailDTO pDTO) {
		
		log.info("domail Start!");
		
		int res =1;
		
		if(pDTO == null) {
			pDTO = new MailDTO();
		}
		
		String toMail = CmmUtil.nvl(pDTO.getToMail());
		
		Properties props = new Properties();
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.auth", "true");
		
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator(){
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(user, password);
			}
		});
		
		log.info("메일주소 ? : " + toMail);
		
		try {
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(user));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(toMail));
			
			message.setSubject(CmmUtil.nvl(pDTO.getTitle()));
			
			message.setText(CmmUtil.nvl(pDTO.getContents()));
			
			Transport.send(message);
			
		}catch(MessagingException e) {
			res=0;
			log.info("에러!" + e);
		}catch(Exception e) {
			res=0;
			log.info("에러!" + e);
		}
		
		log.info(".doSendMail end!!");
		
		return res;
	}
	
}

