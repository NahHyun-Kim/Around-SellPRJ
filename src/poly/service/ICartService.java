package poly.service;

import poly.dto.CartDTO;
import poly.dto.NoticeDTO;

import java.util.List;

public interface ICartService {

    // 장바구니 담기
    int InsertCart(CartDTO pDTO) throws Exception;

    // 장바구니 담기 시, 중복 여부 체크하기
    CartDTO cartChk(CartDTO pDTO) throws Exception;

    // 장바구니 불러오기
    List<CartDTO> myCart(CartDTO pDTO) throws Exception;

    // 장바구니 선택 목록(혹은 전체) 삭제하기
    int deleteCart(CartDTO pDTO) throws Exception;

    // 판매글 수정 시, 장바구니에 담긴 상품인지 체크
    List<CartDTO> updateChk(CartDTO pDTO) throws Exception;

    // 판매글 수정 시, 장바구니 내용도 함께 업데이트
    void updateCart(CartDTO pDTO) throws Exception;

}
