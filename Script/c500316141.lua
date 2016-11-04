	--pendulum summon
function c500316141.initial_effect(c)
		c:EnableReviveLimit()
	--deck check
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(500316141,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c500316141.target)
	e1:SetOperation(c500316141.operation)
	c:RegisterEffect(e1)
		--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c500316141.efilter)
	c:RegisterEffect(e5)
		local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c500316141.condition2)
	e4:SetOperation(c500316141.operation2)
	c:RegisterEffect(e4)
end
function c500316141.mat_filter(c)
	return not c:IsCode(500316141)
end

function c500316141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
end
function c500316141.operation(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x785b) and tc:IsType(TYPE_MONSTER) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local dg=Duel.SelectMatchingCard(tp,c500316141.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	else
		Duel.MoveSequence(tc,1)
	end
end
function c500316141.rmfilter(c)
	return  c:IsFaceup() and c:IsAbleToRemove()
end
function c500316141.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwner()~=e:GetOwner()
end
function c500316141.condition2(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and c:GetMaterial():IsExists(c500316141.pmfilter,1,nil)
end
function c500316141.pmfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x785b) and  c:IsType(TYPE_MONSTER) and not c:IsCode(160003232)
end
function c500316141.operation2(e,tp,eg,ep,ev,re,r,rp)
		--Special Summon
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetDescription(aux.Stringid(500316141,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c500316141.descon)
	e5:SetTarget(c500316141.destg)
	e5:SetOperation(c500316141.desop)
	e5:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	e:GetHandler():RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_TO_DECK)
	e:GetHandler():RegisterEffect(e7)
		local e8=e5:Clone()
	e8:SetCode(EVENT_TO_HAND)
	e:GetHandler():RegisterEffect(e8)
end
function c500316141.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c500316141.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)~=0 --and not c:IsSetCard(0x785b)
end
function c500316141.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c500316141.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c500316141.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c500316141.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c500316141.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
