// Install-time asset pack "rag_assets": the e5 model, its tokenizer and the
// free region packs (app/assets/rag/), ~400 MB together. Play caps the base
// module at 200 MB to download, so the app bundle carries them here instead;
// Play installs the pack together with the app, offline afterwards as before.
//
// Android merges an install-time pack's assets into the app's AssetManager,
// and Flutter reads its assets through that AssetManager at
// `flutter_assets/<key>` — so the files sit at the same paths as in the base
// and rootBundle / AssetManifest in Dart need no change. app/build.gradle.kts
// leaves them out of the base, but only for `bundleRelease`: `flutter run`
// and APKs (which never carry asset packs) keep them in the base.
plugins {
    id("com.android.asset-pack")
}

assetPack {
    packName.set("rag_assets")
    dynamicDelivery {
        deliveryType.set("install-time")
    }
}

val ragDir = rootProject.file("../assets/rag")
// Same list as `ragAssetFiles` in app/build.gradle.kts (left out of the base there).
val ragAssetFiles = listOf("e5_small_int8emb.onnx", "e5_tokenizer.json", "packs/*.db")

val syncRagAssets by tasks.registering(Sync::class) {
    from(ragDir) {
        include(ragAssetFiles)
    }
    into(layout.projectDirectory.dir("src/main/assets/flutter_assets/assets/rag"))
}

tasks.configureEach {
    if (name != syncRagAssets.name && !name.startsWith("clean")) dependsOn(syncRagAssets)
}
