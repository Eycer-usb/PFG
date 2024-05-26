package com.pfg.library;

import org.json.simple.JSONObject;

public interface Orchestrator {
    public JSONObject getOptions();
    public boolean selectOption(String option);
    public boolean isValidOption(String message);
    public int execute();
}
