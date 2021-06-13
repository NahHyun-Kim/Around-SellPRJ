package poly.service.impl;

import java.util.Date;
import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import poly.dto.MailDTO;
import poly.service.IMailService;
import poly.util.CmmUtil;
import poly.util.privateUtil;

@Service("MailService")
public class MailService implements IMailService {

	private Logger log = Logger.getLogger(this.getClass());

	final String host = "smtp.gmail.com";

	@Override
	public int doSendMail(MailDTO pDTO) {

		log.info("domail Start!");

		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		// 이메일 객체생성하기
		Properties props = System.getProperties();


		int res = 1;

		if (pDTO == null) {
			pDTO = new MailDTO();
		}

		String toMail = CmmUtil.nvl(pDTO.getToMail());
		props.setProperty("mail.smtp.host", "smtp.gmail.com");
		props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
		props.setProperty("mail.smtp.socketFactory.fallback", "false");
		props.setProperty("mail.smtp.port", "465");
		props.setProperty("mail.smtp.socketFactory.port", "465");
		props.put("mail.smtp.auth", "true");
		props.put("mail.debug", "true");
		props.put("mail.store.protocol", "pop3");
		props.put("mail.transport.protocol", "smtp");
		final String username = privateUtil.googleMail;
		final String password = privateUtil.googlePw;

		try {
			Session session = Session.getDefaultInstance(props,
					new Authenticator() {
						protected PasswordAuthentication getPasswordAuthentication() {
							return new PasswordAuthentication(username, password);
						}
					});

//메세지 설정
			Message msg = new MimeMessage(session);

//보내는사람 받는사람 설정
			msg.setFrom(new InternetAddress(username));
			msg.setRecipients(Message.RecipientType.TO,
					InternetAddress.parse(CmmUtil.nvl(pDTO.getToMail()), false));
			msg.setSubject(pDTO.getTitle());
			msg.setText(pDTO.getContents());
			msg.setSentDate(new Date());
			Transport.send(msg);
			System.out.println("발신성공!");

			res = 1;
		} catch (MessagingException error) {
			System.out.println("에러가 발생했습니다(메일 전송 실패!) " + error);
			error.printStackTrace();

			res = 0;
		}

		return res;
	}


}