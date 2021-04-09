package me.bristermitten.java2haskell;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class CodeExecutor {
    public static String execute(String haskellCode) throws IOException {
        var workDir = new File("../../work");
        var haskellFile = new File(workDir, "code.hs");
        haskellFile.createNewFile();
        
        try (var writer = new FileWriter(haskellFile)) {
            writer.write(haskellCode);
        }

        new ProcessBuilder("ghc", "code.hs").directory(workDir).start();
        var execProcess = new ProcessBuilder("./code").directory(workDir).start();

        try (var output = execProcess.getInputStream()) {
            return new String(output.readAllBytes());
        } finally {
            haskellFile.delete();
        }
    }
}
