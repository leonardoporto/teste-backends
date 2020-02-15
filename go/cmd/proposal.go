package cmd

import "strconv"

import "time"

type (
	Proposal struct {
		ID                         string
		LoanValue                  float64
		NumberOfMothlyInstallments int64
		Status                     bool
		LastUpdate                 time.Time
		Proponents                 map[string]Proponent
		Warranties                 map[string]Warranty
	}

	Warranty struct {
		ID         string
		Value      float64
		Province   string
		Status     bool
		LastUpdate time.Time
	}

	Proponent struct {
		ID            string
		Name          string
		Age           int64
		MonthlyIncome float64
		isMain        bool
		Status        bool
		LastUpdate    time.Time
	}
)

func create(id string, data []string, date time.Time) (p Proposal) {
	value, _ := strconv.ParseFloat(data[0], 64)
	numberOfMonthly, _ := strconv.ParseInt(data[1], 10, 64)
	p.ID = id
	p.LoanValue = value
	p.NumberOfMothlyInstallments = numberOfMonthly
	p.Status = true
	p.LastUpdate = date
	p.Proponents = make(map[string]Proponent)
	p.Warranties = make(map[string]Warranty)
	return p
}

func createWarranty(data []string, date time.Time) (w Warranty) {
	value, _ := strconv.ParseFloat(data[1], 64)
	w.ID = data[0]
	w.Value = value
	w.Province = data[2]
	w.Status = true
	w.LastUpdate = date
	return
}

func createProponent(data []string, date time.Time) (pp Proponent) {
	age, _ := strconv.ParseInt(data[2], 10, 64)
	income, _ := strconv.ParseFloat(data[3], 64)
	main, _ := strconv.ParseBool(data[4])
	pp.ID = data[0]
	pp.Name = data[1]
	pp.Age = age
	pp.MonthlyIncome = income
	pp.isMain = main
	pp.Status = true
	pp.LastUpdate = date
	return
}

func (p *Proposal) update(data []string, date time.Time) {
	if p.LastUpdate.After(date) {
		return
	}
	value, _ := strconv.ParseFloat(data[5], 64)
	numberOfMonthly, _ := strconv.ParseInt(data[6], 10, 64)
	p.LoanValue = value
	p.NumberOfMothlyInstallments = numberOfMonthly
}

func (p *Proposal) delete(date time.Time) {
	if p.LastUpdate.After(date) {
		return
	}
	p.Status = false
}

func (p *Proposal) warrantyAdd(w Warranty) {
	p.Warranties[w.ID] = w
}

func (p *Proposal) warrantyUpdate(data []string, date time.Time) (result bool) {
	id := data[0]
	w, exists := p.Warranties[id]
	if w.LastUpdate.After(date) {
		return true
	}
	if exists {
		value, _ := strconv.ParseFloat(data[1], 64)
		w.Value = value
		w.Province = data[2]
		result = true
	}
	return
}

func (p *Proposal) warrantyRemove(id string, date time.Time) (result bool) {
	w, exists := p.Warranties[id]
	if w.LastUpdate.After(date) {
		return true
	}
	if exists {
		w.Status = false
		result = true
	}
	return
}

func (p *Proposal) proponentAdd(pp Proponent) {
	p.Proponents[pp.ID] = pp
}

func (p *Proposal) proponentUpdate(data []string, date time.Time) (result bool) {
	id := data[0]
	pp, exists := p.Proponents[id]
	if pp.LastUpdate.After(date) {
		return true
	}
	if exists {
		age, _ := strconv.ParseInt(data[2], 10, 64)
		income, _ := strconv.ParseFloat(data[3], 64)
		main, _ := strconv.ParseBool(data[4])
		pp.ID = data[0]
		pp.Name = data[1]
		pp.Age = age
		pp.MonthlyIncome = income
		pp.isMain = main
		result = true
	}
	return
}

func (p *Proposal) proponentRemove(id string, date time.Time) (result bool) {
	pp, exists := p.Proponents[id]
	if pp.LastUpdate.After(date) {
		return true
	}
	if exists {
		pp.Status = false
		result = true
	}
	return
}
