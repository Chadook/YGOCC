--Ancient Deity River Styx
function c6666666.initial_effect(c)
	c:EnableCounterPermit(0x104)
	c:SetCounterLimit(0x104,8)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666666,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c6666666.condtion)
	e2:SetTarget(c6666666.target)
	e2:SetOperation(c6666666.operation)
	c:RegisterEffect(e2)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c6666666.descon)
	c:RegisterEffect(e4)
	--Add counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_REMOVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c6666666.acop)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x900))
	e6:SetValue(1)
	e6:SetCondition(c6666666.indesco)
	c:RegisterEffect(e6)
	--cannot be target by card effect
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x900))
	e7:SetValue(aux.tgval)
	e7:SetCondition(c6666666.tgcon)
	c:RegisterEffect(e7)
end
function c6666666.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c6666666.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_REMOVED,0,1,nil,0x901)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c6666666.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_REMOVED,0,1,1,nil,0x901)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fc0000)
		tc:RegisterEffect(e3)
	end
end
function c6666666.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_REMOVED,0)==0
end
function c6666666.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK and c:GetPreviousControler()==tp
end
function c6666666.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c6666666.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x104,1)
	end
end
function c6666666.indesco(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x104)>=5
end
function c6666666.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x104)>=8
end