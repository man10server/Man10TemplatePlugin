plugins {
    kotlin("jvm") version "1.9.24"
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

group = "red.man10"
version = "1.1.1"
description = "Man10 Professional Minecraft Plugin Template"

repositories {
    mavenCentral()
    maven("https://repo.papermc.io/repository/maven-public/")
}

dependencies {
    compileOnly("io.papermc.paper:paper-api:1.21-R0.1-SNAPSHOT")
    implementation(kotlin("stdlib"))
}

kotlin {
    jvmToolchain(21)
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(21))
    }
}

tasks.processResources {
    filesMatching("plugin.yml") {
        expand("version" to project.version)
    }
}

tasks.shadowJar {
    archiveBaseName.set("TemplatePlugin")
    archiveClassifier.set("")
}

tasks.build { dependsOn(tasks.shadowJar) }

// 通常のjarタスクを無効化（shadowJarのみ使用）
tasks.jar {
    enabled = false
}

