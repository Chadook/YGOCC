--Galaxy-Eyes Tachyon Dual Lance & Halberd
function c405106.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c405106.mfilter),aux.NonTuner(c405106.mfilter2),1)
	c:EnableReviveLimit()
	--add
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(405106,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,405106)
	e1:SetCondition(c405106.spcon)
	e1:SetTarget(c405106.sptg)
	e1:SetOperation(c405106.spop)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c405106.efilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(405106,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetHintTiming(0,0x1e0)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,405106)
	e3:SetTarget(c405106.intg)
	e3:SetOperation(c405106.inop)
	c:RegisterEffect(e3)
	--disable summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(405106,2))
	e4:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SUMMON)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetCountLimit(1,-405106)
	e4:SetCondition(c405106.condition2)
	e4:SetTarget(c405106.target2)
	e4:SetOperation(c405106.operation2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(405106,3))
	e5:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e5)
end
function c405106.mfilter(c)
	return c:IsSetCard(0x7b)
end
function c405106.mfilter2(c)
	return c:IsSetCard(0x55) or c:IsSetCard(0x7b)
end
function c405106.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c405106.spfilter(c,e,tp)
	return c:IsSetCard(0x55) or c:IsSetCard(0x7b) and c:IsAbleToHand()
end
function c405106.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c405106.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c405106.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c405106.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c405106.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c405106.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER) and tc:IsSetCard(0x55) or tc:IsSetCard(0x7b)
end
function c405106.infilter(c)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c405106.intg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp)end
	if chk==0 then return Duel.IsExistingTarget(c405106.infilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c405106.infilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c405106.inop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsOnField() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c405106.efilter2)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c405106.efilter2(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c405106.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and tp~=ep  and eg:IsExists(c405106.filter2,1,nil)
end
function c405106.filter2(c)
	return c:GetAttack()>=2000 and c:IsAbleToRemove()
end
function c405106.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c405106.filter2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c405106.operation2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c405106.filter2,nil)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end