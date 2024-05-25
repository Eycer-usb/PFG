package com.pfg.library;

import org.json.simple.JSONObject;

public interface Orchestrator {
    public JSONObject getOptions();
    public boolean applyOption(String option);
    public boolean isValidOption(String message);
}
