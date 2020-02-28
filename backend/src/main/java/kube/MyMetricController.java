package kube;

import io.micrometer.stackdriver.StackdriverConfig;
import io.micrometer.stackdriver.StackdriverMeterRegistry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.actuate.autoconfigure.metrics.export.stackdriver.StackdriverMetricsExportAutoConfiguration;
import org.springframework.boot.actuate.autoconfigure.metrics.export.stackdriver.StackdriverProperties;
import org.springframework.boot.actuate.autoconfigure.metrics.export.stackdriver.StackdriverPropertiesConfigAdapter;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Import;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import io.micrometer.core.instrument.MeterRegistry;

import javax.annotation.PostConstruct;
import java.util.Map;

@RestController
public class MyMetricController {
    private static int load = 11;

    @Autowired
    private MeterRegistry meterRegistry;


    @PostConstruct
    private void init() {
        System.out.println(meterRegistry.config());
        meterRegistry.gauge("my_custom_metric", load);

    }

    public int getLoad() {
        return load;
    }


    @GetMapping("/m1")
    public Map<String, Object> getTest() {
        return Map.of("load", load);
    }


    @PutMapping("/m1")
    public void setLoad(@RequestParam(value="load")Integer newLoad ) {
        load = newLoad;
        meterRegistry.gauge("my_custom_metric", load);
    }

}
