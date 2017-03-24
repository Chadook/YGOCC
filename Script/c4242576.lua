--Lunar Phase Beast: Moon Burst Vandalizing
function c4242576.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
		--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4242576,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c4242576.descon1)
	e1:SetTarget(c4242576.destg1)
	e1:SetOperation(c4242576.desop1)
	c:RegisterEffect(e1)
	--On death kill pend scale
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4242576,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCountLimit(1,42425761)
	e2:SetCondition(c4242576.condition)
	e2:SetTarget(c4242576.target)
	e2:SetOperation(c4242576.operation)
	c:RegisterEffect(e2)
		--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(0,LOCATION_SZONE)
	e3:SetTarget(c4242576.distg)
	c:RegisterEffect(e3)
	--disable effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetOperation(c4242576.disop)
	c:RegisterEffect(e4)

end


--Effect 1 (Search) Code
function c4242576.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c4242576.filter(c)
	return c:IsCode(4242564) and c:IsAbleToHand()
end
function c4242576.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c4242576.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c4242576.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c4242576.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--On death kill pend scale
function c4242576.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c4242576.desfilter(c)
	return (c:GetSequence()==6 or c:GetSequence()==7)
end
function c4242576.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4242576.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c4242576.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end


--death into scale
function c4242576.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c4242576.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(1-tp,LOCATION_SZONE,6) or Duel.CheckLocation(1-tp,LOCATION_SZONE,7) end
end
function c4242576.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(1-tp,LOCATION_SZONE,6) and not Duel.CheckLocation(1-tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
--negate
function c4242576.distg(e,c)
	return c:IsType(TYPE_SPELL) and (c:GetSequence()==6 or c:GetSequence()==7)
end
function c4242576.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if re:IsActiveType(TYPE_SPELL) and p~=tp and loc==LOCATION_SZONE and (seq==6 or seq==7) then
		Duel.NegateEffect(ev)
	end
end


