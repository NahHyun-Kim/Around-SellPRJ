package poly.service;

import poly.dto.MailDTO;

public interface IMailService {

	int doSendMail(MailDTO mDTO);

}
