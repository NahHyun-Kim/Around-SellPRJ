package poly.persistance.mapper;

import config.Mapper;
import poly.dto.CartDTO;
import poly.dto.NoticeDTO;

import java.util.List;

@Mapper("CartMapper")
public interface ICartMapper {
    
    // 장바구니 담기
    int InsertCart(CartDTO pDTO) throws Exception;
    
    // 장바구니 불러오기
    List<CartDTO> myCart(CartDTO pDTO) throws Exception;

    // 장바구니 삭제하기
}
