--Lunar Phase: Moon Burst the Storm
function c4242581.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242581,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242581.thcon)
	e1:SetTarget(c4242581.thtg)
	e1:SetOperation(c4242581.thop)
	c:RegisterEffect(e1)
	--Destroy monster
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,42425811)
	e2:SetCondition(c4242581.descon1)
	e2:SetCost(c4242581.descost1)
	e2:SetTarget(c4242581.destg1)
	e2:SetOperation(c4242581.desop1)
	c:RegisterEffect(e2)
	--Kill spell, kill monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242581,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,42425812)
	e3:SetCost(c4242581.descost2)
	e3:SetTarget(c4242581.destg2)
	e3:SetOperation(c4242581.desop2)
	c:RegisterEffect(e3)
end
--Effect 1 (Search) Code
function c4242581.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242581.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242581.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242581.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242581.thop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242581.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end

--Destroy monster
function c4242581.descon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c4242581.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c4242581.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsController(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4242581.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Kill spell, kill monster
function c4242581.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(4242581) and c:IsReleasable()
end
function c4242581.descost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242581.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c4242581.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
end
function c4242581.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4242581.desop2(e,tp,eg,ep,ev,re,r,rp)
  if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end