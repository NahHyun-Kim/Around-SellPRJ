package poly.service;

import poly.dto.CartDTO;
import poly.dto.NoticeDTO;

import java.util.List;

public interface ICartService {

    // 장바구니 담기
    int InsertCart(CartDTO pDTO) throws Exception;

    // 장바구니 불러오기
    List<CartDTO> myCart(CartDTO pDTO) throws Exception;
}
