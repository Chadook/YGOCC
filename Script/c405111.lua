--Galaxy-Eyes Tachyon Particle Ray Dragon
function c405111.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(c405111.mfilter),aux.NonTuner(c405111.mfilter2),1)
	c:EnableReviveLimit()
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(405111,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c405111.atkcon)
	e1:SetTarget(c405111.atktg)
	e1:SetOperation(c405111.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(405111,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,405111)
	e3:SetCondition(c405111.discon)
	e3:SetTarget(c405111.distg)
	e3:SetOperation(c405111.disop)
	c:RegisterEffect(e3)
end
function c405111.mfilter(c)
	return c:IsSetCard(0x7b)
end
function c405111.mfilter2(c)
	return c:IsSetCard(0x55) or c:IsSetCard(0x7b)
end
function c405111.atkfilter(c,e,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and (not e or c:IsRelateToEffect(e))
end
function c405111.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c405111.atkfilter,1,nil,nil,1-tp)
end
function c405111.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
end
function c405111.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c405111.atkfilter,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(c405111.val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(c405111.val)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
	end
end
function c405111.val(e,c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()*-100
	else
		return c:GetLevel()*-100
	end
end
function c405111.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler() and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and rp~=tp
end
function c405111.disfilter(c)
	return c:IsSetCard(0x107b) and c:IsAbleToDeck()
end
function c405111.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c405111.disfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToDeck() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c405111.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c405111.disfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then
		Duel.NegateActivation(ev)
		if re:GetHandler():IsRelateToEffect(re) then
			Duel.SendtoDeck(eg,nil,1,REASON_EFFECT)
		end
	end
end
