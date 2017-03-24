--Lunar Phase Beast: Moon Burst Spell Eater
function c4242571.initial_effect(c)
	--Pendulum Summon
	aux.EnablePendulumAttribute(c)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242574,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242571.descon1)
	e1:SetTarget(c4242571.destg1)
	e1:SetOperation(c4242571.desop1)
	c:RegisterEffect(e1)
	--Destroy Spell & Trap
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242571,1))
	e2:SetCountLimit(1,42425711)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c4242571.descon2)
	e2:SetTarget(c4242571.destg2)
	e2:SetOperation(c4242571.desop2)
	c:RegisterEffect(e2)
	--Destroy Replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4242571,2))
	e3:SetCountLimit(1,42425712)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c4242571.destg3)
	e3:SetValue(c4242571.desval3)
	c:RegisterEffect(e3)	
end

--Effect 1 (Search) Code
function c4242571.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242571.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242571.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242571.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242571.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242571.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
	
--Effect 2 (Destroy spell & trap) Code
function c4242571.descon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c4242571.filter1(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c4242571.destg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c4242571.filter1(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c4242571.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4242571.filter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4242571.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Effect 3 (Destroy Replace) Code
function c4242571.filter3(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x666)
		and (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()~=tp)
end
function c4242571.destg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4242571.filter3,1,nil,tp) end
	return true
end
function c4242571.desval3(e,c)
	return c4242571.filter3(c,e:GetHandlerPlayer())
end