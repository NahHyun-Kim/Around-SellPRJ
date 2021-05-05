package poly.dto;

public class WeatherDTO {

    // 날씨 크롤링을 위한 정보
    private String temperature;
    private String weather;
    private String rainrate;

        public String getRainrate() {
        return rainrate;
    }

    public void setRainrate(String rainrate) {
        this.rainrate = rainrate;
    }

    public String getTemperature() {
        return temperature;
    }

    public void setTemperature(String temperature) {
        this.temperature = temperature;
    }

    public String getWeather() {
        return weather;
    }

    public void setWeather(String weather) {
        this.weather = weather;
    }
}
