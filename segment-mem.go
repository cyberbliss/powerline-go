package main

import (
	"fmt"

	"github.com/shirou/gopsutil/mem"
)

func segmentMem(p *powerline) {
	const unit = 1024
	m, err := mem.VirtualMemory()
	if err != nil {
		return
	}

	div, exp := int64(unit), 0
	for n := m.Available / unit; n >= unit; n /= unit {
		div *= unit
		exp++
	}

	p.appendSegment("mem", segment{
		content:    fmt.Sprintf("\uF799 %.2fG", float64(m.Available)/float64(div)),
		foreground: p.theme.MemFg,
		background: p.theme.MemBg,
	})
}
