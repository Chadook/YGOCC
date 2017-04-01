--Blue-Eyed Silver Pendulum Zombie
function c1013036.initial_effect(c)
	--Pendulum Set
	aux.EnablePendulumAttribute(c)
	--Change Race
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1013036,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c1013036.ratg)
	e2:SetOperation(c1013036.raop)
	c:RegisterEffect(e2)
	--To Grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1013036,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c1013036.gracon)
	e3:SetTarget(c1013036.gratg)
	e3:SetOperation(c1013036.graop)
	c:RegisterEffect(e3)
end
function c1013036.cfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_ZOMBIE)
end
function c1013036.ratg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c1013036.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1013036.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c1013036.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c1013036.raop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_DEFENSE)
	e1:SetValue(0)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(RACE_ZOMBIE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	tc:RegisterEffect(e2)
end
function c1013036.grafilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c1013036.gracon(e,tp,eg,ep,ev,re,r,rp)
	local lv=0
	local g=Duel.GetMatchingGroup(c1013036.grafilter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:GetLevel()>0 and not tc:IsLocation(LOCATION_SZONE) then
			local tlv=tc:GetLevel()
			if tlv>0 then lv=lv+tlv end
		end
		tc=g:GetNext()
	end
	if lv>12 then lv=12 end
	if lv>0 then e:SetLabel(lv) end
	return lv>0 and Duel.IsExistingMatchingCard(c1013036.grafilter,tp,0,LOCATION_MZONE,1,nil)
end
function c1013036.filter(c,lv)
	return c:IsLevelBelow(lv) and c:IsAbleToGrave()
end
function c1013036.gratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1013036.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c1013036.graop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c1013036.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end