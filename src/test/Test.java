package test;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import poly.util.privateUtil;

public class Test {

    // tag값의 정보를 가져오는 메소드
    public static String getTagValue(String tag, Element eElement) {
        NodeList nlList = eElement.getElementsByTagName(tag).item(0).getChildNodes();
        Node nValue = (Node) nlList.item(0);
        if(nValue == null)
            return null;
        return nValue.getNodeValue();
    }

    public static void main(String[] args) {
        int page = 1;   // 페이지 초기값
        try{
            while(true){
                // parsing할 url 지정(API 키 포함해서)
                String url = "http://openAPI.seoul.go.kr:8088/" + privateUtil.openApi + "/xml/ListAirQualityByDistrictService/1/25/";

                DocumentBuilderFactory dbFactoty = DocumentBuilderFactory.newInstance();
                DocumentBuilder dBuilder = dbFactoty.newDocumentBuilder();
                Document doc = dBuilder.parse(url);

                // root tag
                doc.getDocumentElement().normalize();
                System.out.println("Root element :" + doc.getDocumentElement().getNodeName());

                // 파싱할 tag
                NodeList nList = doc.getElementsByTagName("row");
                System.out.println("파싱할 리스트 수 : "+ nList.getLength());

                for(int temp = 0; temp < nList.getLength(); temp++){
                    Node nNode = nList.item(temp);
                    if(nNode.getNodeType() == Node.ELEMENT_NODE){
                        // 여기서 가게넘버 불러와 변수저장

                        //if()문안에 저장한 변수 == 밑의 소스 불러오기
                        Element eElement = (Element) nNode;
                        System.out.println("######################");

                    }   // if end
                }   // for end

                page += 1;
                System.out.println("page number : "+page);
                if(page > 12){
                    break;
                }
            }   // while end

        } catch (Exception e){
            e.printStackTrace();
        }   // try~catch end
    }   // main end
}   // class end