package poly.service;

import poly.dto.WeatherDTO;

public interface IWeatherService {

    // 날씨 정보 크롤링
    WeatherDTO getWeather(String addr2) throws Exception;

    // 내일 날씨
    WeatherDTO getNext(WeatherDTO pDTO) throws Exception;
}
