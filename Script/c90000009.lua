--Night Clock Assassin
function c90000009.initial_effect(c)
	--Fusion Material
	aux.AddFusionProcCodeFun(c,90000006,aux.FilterBoolFunction(Card.IsFusionSetCard,0x3),1,true,true)
	c:EnableReviveLimit()
	--Set Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c90000009.condition)
	e1:SetTarget(c90000009.target)
	e1:SetOperation(c90000009.operation)
	c:RegisterEffect(e1)
	--Attack All
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Activate Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c90000009.condition2)
	e3:SetValue(c90000009.value)
	c:RegisterEffect(e3)
end
function c90000009.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION and re:GetHandler():IsSetCard(0x3)
end
function c90000009.filter(c)
	return c:IsSetCard(0x3) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c90000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c90000009.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c90000009.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c90000009.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x17a0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c90000009.value(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c90000009.condition2(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end