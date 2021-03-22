package poly.dealprj.controller;

import org.springframework.boot.Banner;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class TestController {

    @GetMapping("test")
    public String test(Model model) {
        model.addAttribute("test", "success!!");
        return "test";
    }

    @GetMapping("test-mvc")
    //실행 후 get 방식으로 name?=이름명 입력 시, html에 이름으로 치환되어 출력됨
    public String testMvc(@RequestParam(name = "name") String name, Model model) {
        model.addAttribute("name", name);
        return "test-template";
    }

    @GetMapping("test-string")
    @ResponseBody
    public String testString(@RequestParam("name") String name) {
        return "hello " + name; //hello 와 입력한 이름값으로 출력
    }

    @GetMapping("test-api")
    @ResponseBody
    public Test testApi(@RequestParam("name") String name) {
        Test test = new Test();
        test.setName(name);
        return test;
    }

    static class Test {
        private String name;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

    }
}
