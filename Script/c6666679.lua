--Ancient Deity River Phlegethon
function c6666679.initial_effect(c)
	c:EnableCounterPermit(0x105)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--place
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6666679,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCondition(c6666679.condtion)
	e2:SetTarget(c6666679.target)
	e2:SetOperation(c6666679.operation)
	c:RegisterEffect(e2)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c6666679.descon)
	c:RegisterEffect(e4)
	--Add counter
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_REMOVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c6666679.acop)
	c:RegisterEffect(e5)
	--atkdown
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetValue(c6666679.atkval)
	c:RegisterEffect(e6)
	--burn
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(6666679,0))
	e7:SetRange(LOCATION_SZONE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTarget(c6666679.dtrg)
	e7:SetOperation(c6666679.dop)
	c:RegisterEffect(e7)
end
function c6666679.condtion(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function c6666679.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_REMOVED,0,1,nil,0x901)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c6666679.operation(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c6666679.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_REMOVED,0)==0
end
function c6666679.cfilter(c,tp)
	return c:GetPreviousLocation()==LOCATION_DECK and c:GetPreviousControler()==tp
end
function c6666679.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c6666679.cfilter,1,nil,tp) then
		e:GetHandler():AddCounter(0x105,1)
	end
end
function c6666679.atkval(e,c)
	return e:GetHandler():GetCounter(0x105)*-200
end
function c6666679.dfilter(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanRemoveCounter(tp,0x105,ct,REASON_COST)
end
function c6666679.dtrg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetHandler():GetCounter(0x105)
	if chkc then return c6666679.dfilter(chkc,e:GetHandler(),tp) end
	if chk==0 then return ct~=0 end
	e:GetHandler():RemoveCounter(tp,0x105,ct,REASON_COST)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c6666679.dop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
