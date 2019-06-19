package io.gazetteer.tilestore.file;

import io.gazetteer.tilestore.Tile;
import io.gazetteer.tilestore.TileException;
import io.gazetteer.tilestore.TileReader;
import io.gazetteer.tilestore.TileWriter;
import io.gazetteer.tilestore.XYZ;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardOpenOption;

public class FileTileStore implements TileReader, TileWriter {

  private final Path directory;

  public FileTileStore(Path directory) {
    this.directory = directory;
  }

  @Override
  public Tile read(XYZ xyz) throws TileException {
    Path path = path(xyz);
    if (!Files.exists(path)) {
      return null;
    }
    try {
      return new Tile(Files.readAllBytes(path));
    } catch (IOException e) {
      throw new TileException(e);
    }
  }

  @Override
  public void write(XYZ xyz, Tile tile) throws TileException {
    Path path = path(xyz);
    try {
      Files.write(path, tile.getBytes(), StandardOpenOption.CREATE_NEW, StandardOpenOption.TRUNCATE_EXISTING);
    } catch (IOException e) {
      throw new TileException(e);
    }
  }

  private Path path(XYZ xyz) {
    return directory
        .resolve(Integer.toString(xyz.getZ()))
        .resolve(Integer.toString(xyz.getX()))
        .resolve(Integer.toString(xyz.getY()));
  }

}