package poly.dto;

public class WeatherDTO {

    // 날씨 크롤링을 위한 정보
    private String temperature;
    private String weather;
    private String rainrate;
    private String day;
    private String addr2;
    private String imgs;

    // api 이용을 위한 정보
    private String msrstename; // 측정소명(자치구)
    private String grade; // 지수 등급
    private String pm10; // 미세먼지 농도
    private String pm25; // 초미세먼지 농도

    public String getPm10() {
        return pm10;
    }

    public void setPm10(String pm10) {
        this.pm10 = pm10;
    }

    public String getPm25() {
        return pm25;
    }

    public void setPm25(String pm25) {
        this.pm25 = pm25;
    }

    public String getMsrstename() {
        return msrstename;
    }

    public void setMsrstename(String msrstename) {
        this.msrstename = msrstename;
    }

    public String getGrade() {
        return grade;
    }

    public void setGrade(String grade) {
        this.grade = grade;
    }

    public String getImgs() {
        return imgs;
    }

    public void setImgs(String imgs) {
        this.imgs = imgs;
    }

    public String getAddr2() {
        return addr2;
    }

    public void setAddr2(String addr2) {
        this.addr2 = addr2;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

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
