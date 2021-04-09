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

        var compileProcess = new ProcessBuilder("ghc", "code.hs").directory(workDir).start();
        var errors = new String(compileProcess.getErrorStream().readAllBytes());

        if(!errors.isBlank()) {
            return "Errors Compiling: " + errors;
        }
        var execProcess = new ProcessBuilder("./code").directory(workDir).inheritIO().start();

        try (var output = execProcess.getInputStream()) {
            return new String(output.readAllBytes());
        } finally {
            haskellFile.delete();
        }
    }
}
