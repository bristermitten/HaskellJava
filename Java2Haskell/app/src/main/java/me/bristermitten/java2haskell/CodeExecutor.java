package me.bristermitten.java2haskell;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.lang.ProcessBuilder.Redirect;

public class CodeExecutor {
    public static String execute(String haskellCode) throws IOException {
        var workDir = new File("../../work");
        var haskellFile = new File(workDir, "code.hs");
        haskellFile.createNewFile();

        try (var writer = new FileWriter(haskellFile)) {
            writer.write(haskellCode);
        }

        var compileProcess = new ProcessBuilder("ghc", "code.hs").directory(workDir).inheritIO().redirectError(Redirect.PIPE).start();
        var errors = new String(compileProcess.getErrorStream().readAllBytes());

        if (!errors.isBlank()) {
            return "Errors Compiling: " + errors;
        }

        new ProcessBuilder("./code").directory(workDir).inheritIO().start();
        return "";
    }
}
