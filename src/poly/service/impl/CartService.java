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

    // 장바구니 담기 시, 중복 여부 체크하기
    @Override
    public CartDTO cartChk(CartDTO pDTO) throws Exception {
        return cartMapper.cartChk(pDTO);
    }

    // 장바구니 불러오기
    @Override
    public List<CartDTO> myCart(CartDTO pDTO) throws Exception {
        return cartMapper.myCart(pDTO);
    }

    // 장바구니 선택 목록(혹은 전체) 삭제하기
    @Override
    public int deleteCart(CartDTO pDTO) throws Exception {
        return cartMapper.deleteCart(pDTO);
    }

    // 판매글 수정 시, 장바구니에 담긴 상품인지 체크
    @Override
    public List<CartDTO> updateChk(CartDTO pDTO) throws Exception {
        return cartMapper.updateChk(pDTO);
    }

    // 판매글 수정 시, 장바구니 내용도 함께 업데이트
    @Override
    public void updateCart(CartDTO pDTO) throws Exception {
        cartMapper.updateCart(pDTO);
    }

}
