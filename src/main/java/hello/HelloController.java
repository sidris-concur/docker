package hello;

import java.util.Date;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {
    
    @RequestMapping("/")
    public String index() {
    	String msg = new Date() + ": Hello " + System.getenv("NAME");
    	System.out.println(msg);
        return msg;
    }   
}
