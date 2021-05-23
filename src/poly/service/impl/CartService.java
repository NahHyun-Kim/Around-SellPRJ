package poly.service.impl;

import org.springframework.stereotype.Service;
import poly.dto.CartDTO;
import poly.dto.NoticeDTO;
import poly.persistance.mapper.ICartMapper;
import poly.persistance.mapper.INoticeMapper;
import poly.service.ICartService;

import javax.annotation.Resource;
import java.util.List;

@Service("CartService")
public class CartService implements ICartService {

    // CartMapper를 메모리에 올림
    @Resource(name="CartMapper")
    private ICartMapper cartMapper;

    // 장바구니 담기
    @Override
    public int InsertCart(CartDTO pDTO) throws Exception {
        return cartMapper.InsertCart(pDTO);
    }
    // 장바구니 불러오기
    public List<CartDTO> myCart(CartDTO pDTO) throws Exception {
        return cartMapper.myCart(pDTO);
    };
}
