package main

import (
	"fmt"
	"io/ioutil"
	"path"
	"path/filepath"

	"gopkg.in/ini.v1"
)

func getActiveConfig() (string, error) {
	path := path.Join(homePath(), ".config", "gcloud", "active_config")
	absolutePath, err := filepath.Abs(path)
	if err != nil {
		return "", err
	}

	fileContent, err := ioutil.ReadFile(absolutePath)
	if err != nil {
		return "", err
	}

	return string(fileContent), nil

}

func segmentGcloud(p *powerline) {
	configFile, err := getActiveConfig()
	if err != nil {
		fmt.Println("ERROR: ", err)
		return
	}

	path := path.Join(homePath(), ".config", "gcloud", "configurations", "config_"+configFile)

	cfg, err := ini.Load(path)
	if err != nil {
		return
	}
	gcloudProject := cfg.Section("core").Key("project").String()

	if gcloudProject != "" {
		content := fmt.Sprintf("%s %s", p.symbolTemplates.Cloud, gcloudProject)
		p.appendSegment("gcloud", segment{
			content:    content,
			foreground: p.theme.GcloudFg,
			background: p.theme.GcloudBg,
		})
	}
}
