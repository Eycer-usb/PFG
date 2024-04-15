import com.pfg.library.Observer;

import static org.junit.Assert.assertTrue;

import org.json.simple.JSONObject;
import org.junit.Test;

public class ObserverTest {


    @Test
    public void testConnection() {
        JSONObject config = new JSONObject();
        config.put("address", "192.168.0.112");
        config.put("port", "43316");
        Observer observer = new Observer(config);
        boolean status = observer.connect();
        assertTrue(status);
        status = observer.disconnect();
        assertTrue(status);
    }
}
